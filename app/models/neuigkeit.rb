# == Schema Information
#
# Table name: neuigkeiten
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  text       :text
#  datum      :datetime
#  rubrik_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#

class Neuigkeit < ActiveRecord::Base
  attr_accessible :datum, :text, :title, :rubrik_id, :author_id,:picture,:picture_cache, :calentries_attributes, :flag_important
  belongs_to :author, :class_name =>'User'
  belongs_to :rubrik, :class_name =>'Rubrik', :foreign_key => "rubrik_id"
  has_one :calendar, through: :rubrik  
  has_many :calentries, as: :object, :dependent=> :destroy
  has_many :nlinks, :dependent=> :destroy   
  has_one :meeting
  has_many :attachments, :as=>:parent
  has_one :title_pic, :class_name=>"Attachment", :as=>:parent, :conditions=>["attachments.flag_titlepic =?", true]

  has_many :questions,  :class_name=>"Survey::Question", as: :parent

  validates :rubrik, :presence=>true
  validates :author, :presence=>true
  translates :title,:text, :versioning=>{:gem=>:paper_trail, :options=>{:fallbacks_for_empty_translations => true}}
  globalize_accessors :locales => [:de, :en], :attributes =>[:text,:title]
  mount_uploader :picture, PictureUploader

  default_scope  order(:cache_order).includes(:calentries).includes(:title_pic)
  scope :recent, -> { published.limit(10)}
  scope :unpublished, -> {where("datum > ? OR datum IS NULL", Time.now)}
  scope :published_scope, ->{where("datum <= ? AND datum IS NOT NULL", Time.now)}
  scope :public, ->{includes(:rubrik).where("rubriken.public"=>true)}
  scope :intern, ->{includes(:rubrik).where("rubriken.public"=>false)}

#  scope :search, ->(query) {where("text like ? or title like ?", "%#{query}%", "%#{query}%")}
  LINKTYPES=["Thema", "Themengruppe", "Gallery", "Lva","Studium","Fetprofile", "Gremium"]
  accepts_nested_attributes_for :calentries, :allow_destroy=>true , :reject_if=> lambda{|a| a[:start].blank?}
  before_validation :sanitize
  after_save :update_cache
  attr_accessor :no_fallbacks
  def globalize_fallbacks(locale)
    if self.no_fallbacks
    [locale]
    else
      super
    end
  end
  def read_attribute(name,options={})
    if translated?(name)
      a=super(name,options)      
      a=self.translation_for(options[:locale] || I18n.locale).read_attribute(name) if self.no_fallbacks 
      
      a
    else 
      super(name)
    end
  end
  def picture_robust
    unless self.picture.url.nil?
      return self.picture
    else
      if self.has_meeting?
       return self.meeting.meetingtyp.picture
      else
        unless self.title_pic.nil?
        #  return self.attachments.where(flag_titlepic: true).first.datei
          return self.title_pic.datei
        else
          return self.picture
        end
      end
    end
  end
  def is_annoncement?
    !self.meeting.nil?
  end
  def has_meeting?
    !self.meeting.nil?
  end
  def self.published
    where("datum <= ? AND datum IS NOT NULL", Time.now.to_date)  
  end

  def datum_nilsave
	self.datum.nil? ? Time.now + 42.years : self.datum
  end
  def public?
    self.rubrik.public
  end
  def published?
   self.datum_nilsave<=Time.now
  end

  def publish
    self.datum = Time.now
  end
  def reverse_publish
    self.datum = nil
  end
  def name
    self.title
  end
  def load_from_facebook(link)
    event=FbGraph::Event.new(link).fetch(:access_token=>"CAABtfB8SO7kBADyHVHnWHqsxsU1bqqmeDdZCp7V1KF9G4o3oFHcZBq0IB8X3ird4muVIPuWKZB8jL1o9JCON60Lmnvk8rkZA2dyZAuU95dC0SWzOEnhtAEkyzZCN6hkKXdl87o38OloLBivc2kjJYmpUVKzdZAD5ywxKG7Hv5FWxXf6amWA782JSmcxgWsRDH4ZAZBXsUrhpnILNOVoKSBf1mGyfrFiPvA3QZD")
    self.title=event.name
    self.text=event.description
    unless event.start_time.nil?
      ce=Calentry.new(:start=>event.start_time, :ende=>event.end_time , :typ=>1)
      ce.ende=ce.start if ce.ende.nil?
      self.calentries<< ce
      ce.save

    end
  end
  def text_first_words
    md = /<p>(?<text>[^\<\>]*)/.match Sanitize.clean(self.text,:elements=>['p'])
    words=md[:text].split(" ") unless md.nil?
    if words.nil? || words.empty?
      "...."
    else
      words[0..100].join(" ")+ " ..." unless  words.nil?
      
    end
  end
  def has_calentries?
    !self.calentries.nil? && !self.calentries.empty?
  end
  def is_event?
    self.has_calentries?
  end
  def relevant_calentry
    ce = self.calentries.min_by{|c| c.days_to_today * 1.3 * ((c.is_past?)? 2:1)} if self.is_event?
    ce= self.meeting.calentry if self.has_meeting? 
    ce
  end
  def update_cache
    if self.has_meeting? && !self.meeting.calentry.nil?
      self.update_column(:cache_order, (self.meeting.calentry.start.to_date - Date.today).to_i.abs * 1.3)
      self.update_column(:cache_relevant_date, self.meeting.calentry.start.to_date)
      self.touch
    else 
      if self.is_event? 
        c = self.calentries.min_by{|c| c.days_to_today * 1.3 * ((c.is_past?)? 2:1)}
        self.update_column(:cache_order,  c.days_to_today * 1.3 * ((c.is_past?)? 2:1))
        self.update_column(:cache_relevant_date, (c.is_past?) ? c.ende.to_date : c.start.to_date)
        self.touch
      else
        unless self.datum.nil?
          self.update_column(:cache_order, (((self.datum.to_date - Date.today).to_i)).abs)
          self.update_column(:cache_relevant_date, self.datum.to_date)
        else
          self.update_column(:cache_order,0)
        end
      end
    end
    unless self.published?
      self.update_column(:cache_order, self.cache_order-14)
    end
    if self.flag_important
      self.update_column(:cache_order, self.cache_order-10)
    end
    self.update_column(:cache_is_published, self.published?)
  end

  private
  def sanitize
    self.calentries.each do |calentry|
      calentry.calendar= self.rubrik.calendar
      calentry.typ=1
      calentry.object=self
    end
  end
  searchable do
    text :text 
    text :datum
    text :title, :boost=>3.0
  end
end
