# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: lvas
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  desc        :text
#  ects        :decimal(, )
#  lvanr       :string(255)
#  stunden     :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  modul_id    :integer
#  semester_id :integer
#

class Lva < ActiveRecord::Base
  has_paper_trail # Versionsverfolgung
  attr_accessible :desc, :ects, :lvanr, :name, :stunden, :modul_ids
  
  has_and_belongs_to_many :modul # Gehört zu einem Modul
  has_and_belongs_to_many :semester # Gehört zu einem Semester( derzeit nicht implementiert)
  has_many :beispiele , :class_name => "Beispiel"

  translates :desc,  :fallbacks_for_empty_translations => true
  
  validates :lvanr,:format=>{ :with => /^[0-9][0-9][0-9]\.[0-9][0-9][0-9]$/} # , :uniqueness=>true # LVA-Nummer muss das Format 000.000 besitzen (uniqueness?) oder 000 für nicht existent
  
  validates_presence_of :ects  # ECTS vorhanden?
  validates_presence_of :name # Name Eingetragen?
  validates_presence_of :stunden # Stunden Eingetragen?
  validates_presence_of :modul # Zugehöriges Modul eingetragen? (zumindest eines)
private

##
# Lade Daten aus TISS und füge diese in die Datenbank ein. 
def load_tissdata
  url= "https://tiss.tuwien.ac.at/api/course/"+ self.lvanr.to_s+"-2012W"
  begin 
    @hash=Hash.from_xml(open(url).read)["tuvienna"]
    @person=[] 
    if @hash["course"]["lecturers"]["oid"].is_a? String
      @person = @hash["course"]["lecturers"]["oid"]
    else
      @hash["course"]["lecturers"]["oid"].each do |pid|
        @person << Hash.from_xml(open("https://tiss.tuwien.ac.at/adressbuch/adressbuch/person_via_oid/" + pid.to_s + ".xml").read)["tuvienna"]["person"]
      end
    end
  rescue OpenURI::HTTPError => e
  end 
end



end
