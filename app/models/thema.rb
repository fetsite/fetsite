
# == Schema Information
#
# Table name: themen
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  text             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  themengruppe_id  :integer          ID of themengruppe
#  isdraft          :boolean          True if this topic is only a draft an should not be visible to public
#   hidelink        :boolean          true if link to this topic should not be visible in the list
#  hideattachment   :boolean          hide the attachment table in the view - doesnt hide attachments that are linked and doesn't protect them
#  sticky_startpage :boolean          if true topic is sticked on the start page
#  sticky_intern    : boolean         if true this topic is sticked at the intern page
require 'uri'
class Thema < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  # Properties that should be accesible
  attr_accessible :text, :title, :themengruppe_id,:isdraft, :hidelink, :hideattachment, :sticky_startpage,:sticky_intern
  # Each topic has multiple questions, that are also referenced in the FAQ. 
  has_many :fragen
  # Attachments can be all data formats
  has_many :attachments, :as=>:parent
  # attached pics can be used as title pictures
  has_many :titlepics, :as=>:parent, :class_name=>'Attachment', :conditions=>{:flag_titlepic=>true}
  # each topic has to belong to one group 
  belongs_to :themengruppe, :foreign_key => "themengruppe_id", :touch=>true
  validates :themengruppe, :presence => true
  # a topic can be linked to a gremium
  has_one :gremium
  # a topic can be attached to news
  has_many :nlinks, as: :link
  # each topic can have multiple meetings
  has_many :meetings, :as=>:parent
  # each topic can have multiple documents
  has_many :documents, :as=>:parent
  
  validates :title, :presence => true
  validates :text, :presence => true
  
  scope :outdated, -> {includes(:translations).where("thema_translations.updated_at<?",7.month.ago).where("thema_translations.locale"=>I18n.locale)}
  scope :public, where(:isdraft=>false).includes(:themengruppe).where("themengruppen.public"=>true)

  default_scope includes(:translations).order("themen.priority").reverse_order
  # make topic searchable 
  searchable do
    text :text
    text :title, :boost=>4.0
  end

  resourcify  
  # title and text can have 
  translates :title,:text, :versioning =>true, :fallbacks_for_empty_translations => true

  def is_outdated?
    unless translation.try(:updated_at).nil?
      translation.updated_at < 7.month.ago
    else
      false
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
  
  def fix_links(host)
    full_url= URI.parse(root_url(:host=>host))
    self.text.gsub!(/src="[\.\/]*uploads\/attachment\/datei\/(\d+)\/thumb_big[^"]*"/){|s| full_url.path=Attachment.find($1.to_i).datei.thumb_big.url; 'src="'+full_url.to_s+'"'}
    self.text.gsub!(/src="[\.\/^"]*uploads\/attachment\/datei\/(\d+)\/[^"]*"/){|s| full_url.path=Attachment.find($1.to_i).datei.url; 'src="'+full_url.to_s+'"'}
    self.text.gsub!(/href="[^"]*themen\/(\d+)[^"]*"/){|s| full_url.path=thema_path(Thema.find($1.to_i)); 'href="'+full_url.to_s+'"'}
  end
end
