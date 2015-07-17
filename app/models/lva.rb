# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: lvas
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  desc                 :text
#  ects                 :decimal(, )
#  lvanr                :string(255)
#  stunden              :decimal(, )
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  modul_id             :integer
#  semester_id          :integer
#  pruefungsinformation :text
#  lernaufwand          :text
#  typ                  :string(255)
#

# == Schema Information
#
# Table name: lvas
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  desc        :text
#  ects        :decimal
#  lvanr       :string(255)
#  stunden     :decimal
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  modul_id    :integer
#  semester_id  :integer

class Lva < ActiveRecord::Base
  ERLAUBTE_TYPEN = ['VO', 'UE', 'VU', 'LU', 'SE', 'PR', 'andere'];
  translates :desc,:pruefungsinformation,  :fallbacks_for_empty_translations => true, :versioning=> :paper_trail #true #{:gem=>:paper_trail}
  has_paper_trail :ignore=>[:desc, :pruefungsinformation]# Versionsverfolgung
  

  attr_accessible :desc, :ects, :lvanr, :name, :stunden, :modul_ids, :semester_ids, :pruefungsinformation, :lernaufwand, :typ, :lecturer_ids, :forumlink

  has_and_belongs_to_many :modul,:uniq=>true # Gehört zu einem Modul
  has_and_belongs_to_many :semester
  has_many :beispiele , :class_name => "Beispiel"

  has_and_belongs_to_many :lecturers
  has_many :nlinks, as: :link
  has_many :crawlobjects, :as=>:something
#  scope :search, ->(query) {where("name like ? or lvas.desc like ?", "%#{query}%", "%#{query}%")} 
  
  validates :lvanr,:format=>{ :with => /^[0-9][0-9][0-9]\.[0-9A][0-9][0-9]$/}, :presence=>true, :uniqueness=>true # , :uniqueness=>true # LVA-Nummer muss das Format 000.000 besitzen (uniqueness?) oder 000 für nicht 
  validates_presence_of :ects  # ECTS vorhanden?
  validates :name, :presence=>true, :uniqueness=>{:scope=>:typ}# Name Eingetragen?
  validates :typ, :presence=>true, :inclusion=> ERLAUBTE_TYPEN
  validates_presence_of :stunden # Stunden Eingetragen?
  validates_presence_of :modul # Zugehöriges Modul eingetragen?
  # (zumindest eines)

  def typ_n
    typ=="andere" ? "" : typ
  end
  def title
    self.name
  end
  def full_name
    return self.typ_n + ' ' + self.name
    end
  def add_semesters
    # Diese Methode fügt die Instanz automatisch zu allen Studien als "Ohne Semesterempfehlung" (Semester 0) zu, bei denen die Instanz im Studium noch nicht vorkommt.
    for m in self.modul
      for mg in m.modulgruppen # Über alle Module und alle Modulgruppen iterieren
        hits = mg.studium.semester.all.map{|x| x.lvas}.map{|x| x.find_by_id(self.id)}.compact # Alle einträge in allen semestern mit gleicher LVa-ID suchen und alle nils entfernen

        if hits.empty? # wurde gar kein eintrag gefunden ?
          self.semester << mg.studium.semester.where(:nummer => 0) # auf nummer null eintragen
        end
      end
    end
    
  end
 
  ##
  # Lade Daten aus TISS und füge diese in die Datenbank ein. 
  def tisshash(semester)
   url= "https://tiss.tuwien.ac.at/api/course/"+ lvanr.to_s.gsub(".","")+semester
  hash=Hash.from_xml(open(url).read)["tuvienna"]
  end

  def tisslink   
    urlp="https://tiss.tuwien.ac.at/course/courseDetails.xhtml?courseNr="+ lvanr.to_s.gsub(".","")+"&"
    urlp1 = "https://tiss.tuwien.ac.at/api/course/"+ lvanr.to_s.gsub(".","")+"-"
    begin
      url= urlp+"semester="+Time.now.year.to_s+"W"
      hash=Hash.from_xml(open(urlp1+Time.now.year.to_s+"W").read)["tuvienna"]
    rescue OpenURI::HTTPError => e
      begin
        url= urlp+"semester="+Time.now.year.to_s+"S"
        hash=Hash.from_xml(open(urlp1+Time.now.year.to_s+"S").read)["tuvienna"]
      rescue OpenURI::HTTPError => e
        begin
          url= urlp+"semester="+(Time.now.year-1).to_s+"W"
          hash=Hash.from_xml(open(urlp1+(Time.now.year-1).to_s+"W").read)["tuvienna"]
        rescue OpenURI::HTTPError => e
        end 
      end 
      rescue => e 

    end 
    url
  end


  def load_tissdata
    urlp="https://tiss.tuwien.ac.at/api/course/"+ lvanr.to_s.gsub(".","")+"-"
    begin
      url= urlp+Time.now.year.to_s+"W"
      hash=Hash.from_xml(open(url).read)["tuvienna"]
    rescue OpenURI::HTTPError => e
      begin
        url= urlp+Time.now.year.to_s+"S"
        hash=Hash.from_xml(open(url).read)["tuvienna"]
      rescue OpenURI::HTTPError => e
      begin
        url= urlp+(Time.now.year-1).to_s+"W"
        hash=Hash.from_xml(open(url).read)["tuvienna"]
      rescue OpenURI::HTTPError => e
        
      end 
        
      end 
      
    end 
 


#    begin 
 
  #    person=[] 
  #    if hash["course"]["lecturers"]["oid"].is_a? String
  #      person = @hash["course"]["lecturers"]["oid"]
  #    else
  #      hash["course"]["lecturers"]["oid"].each do |pid|
  #        person << Hash.from_xml(open("https://tiss.tuwien.ac.at/adressbuch/adressbuch/person_via_oid/" + pid.to_s + ".xml").read)["tuvienna"]["person"]
  #      end
  #    end
    self.name=hash["course"]["title"]["de"]
    self.pruefungsinformation =  hash["course"]["examinationModalities"][I18n.locale.to_s].to_s unless hash["course"]["examinationModalities"][I18n.locale.to_s].to_s.empty?
    self.desc= hash["course"]["objective"][I18n.locale.to_s]+"<p></p>"+hash["course"]["teachingContent"][I18n.locale.to_s]
    self.typ=hash["course"]["courseType"]
    self.stunden=hash["course"]["weeklyHours"]
    #hash["course"]["url"]  
    if hash["course"]["lecturers"]["oid"].is_a? Array
      hash["course"]["lecturers"]["oid"].each do |oid|
        lecturer= self.lecturers.where(:oid=>oid).first
        if lecturer.nil?
          lecturer=Lecturer.where(:oid=>oid).first
          if lecturer.nil?
            logger.debug "Neuen Lecturer laden"
            lecturer=Lecturer.new
            lecturer.oid=oid
            lecturer.load_tissdata
            if lecturer.save
              self.lecturers << lecturer
            else
              logger.fatal "Invaliden Lecturer erzeugt"
            end
          else
            logger.debug "Lecturer hinzufügen"
            self.lecturers << lecturer
          end
        end
      end
    else
      oid=  hash["course"]["lecturers"]["oid"]
      lecturer= self.lecturers.where(:oid=>oid).first
      if lecturer.nil?
        lecturer=Lecturer.where(:oid=>oid).first
        if lecturer.nil?
          logger.info "Neuen Lecturer laden"
          lecturer=Lecturer.new
          lecturer.oid=oid
            lecturer.load_tissdata
          if lecturer.save
            self.lecturers << lecturer
          else
            logger.fatal "Invaliden Lecturer erzeugt"
          end
        else
          
          logger.info "Lecturer hinzufügen"
          lecturer.load_tissdata
          lecturer.save
          self.lecturers << lecturer
        end
      end
    

    end
    
  end

  def update_multiple(hash)
    newlvas=[]
    params["lvas"].each do |i,l|
      lva=Lva.where(:lvanr=>l["lvanr"]).first if lva.nil?
      lva=Lva.new(l) if lva.nil?

      lva.name=l["name"]
      lva.lvanr=l["lvanr"]
      lva.ects=l["ects"]
      descr = l["desc"]
      lva.desc= (descr.empty?) ? "<div></div>" : descr
      lva.semester=Semester.where(:id=>l["semester_ids"].map(&:to_i))
      lva.stunden=l["stunden"]
      pr =l["pruefungsinformation"]
      lva.pruefungsinformation= (pr.empty?) ? "<div></div>" : pr
      lva.lernaufwand=l["lernaufwand"]
      lva.typ=l["typ"]
      lva.save
      newlvas<<lva #
    end 
    newlvas
    
  end

 searchable do
    text :desc
    text :pruefungsinformation
    text :lernaufwand
    text :typ
    text :name, :boost=>3.0
    text :lecturer_names do
      lecturers.map { |l| l.name }
    end
  end

  def self.update_multiple_with_modul(hash,modul)
    newlvas=[]
    hash.each do |i,l|
      lva=Lva.where(:lvanr=>l["lvanr"]).first if lva.nil?
      lva=Lva.new(l) if lva.nil?
      lva.modul<< modul
      lva.modul.uniq!
      lva.name=l["name"]
      lva.lvanr=l["lvanr"]
      lva.ects=l["ects"]
      descr = l["desc"]
      lva.desc= (descr.empty?) ? "<div></div>" : descr
      lva.semester=Semester.where(:id=>l["semester_ids"].map(&:to_i))
      lva.stunden=l["stunden"]
      pr =l["pruefungsinformation"]
      lva.pruefungsinformation= (pr.empty?) ? "<div></div>" : pr
      lva.lernaufwand=l["lernaufwand"]
      lva.typ=l["typ"]
      lva.save
      newlvas<< lva #
    end 
    newlvas
    
  end


  def read_et_forum
    lva=self
    url=lva.forumlink
    ans = JSON.parse(`python #{Rails.root}/bin/downloadlogin.py #{url}`)
    ans.each do |a|
      if Crawlobject.where(:objhash=>Digest::SHA512.hexdigest(a.to_json), :objtype=>1).count ==0
        aa = Crawlobject.new(:raw=>a.to_json)
        aa.objtype=1
        aa.parse_object
        aa.calc_hash
        aa.something=lva
        if Crawlobject.where(:objhash2=>aa.objhash2, :objtype=>1).count==0
            aa.save
        else
          aa=Crawlobject.where(:objhash2=>aa.objhash2).first
          aa.raw=a.to_json
          aa.parse_object
          aa.calc_hash
          aa.save
        end
      end
    end
  end


 
end

