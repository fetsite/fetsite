# == Schema Information
#
# Table name: beispiele
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  desc          :text
#  lva_id        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  beispieldatei :string(255)
#

class Beispiel < ActiveRecord::Base
  has_paper_trail
  attr_accessible :desc, :name, :lva_id, :beispieldatei, :beispieldatei_cache, :datum, :lecturer_id
  acts_as_votable
  acts_as_flagable
  belongs_to :lva

  belongs_to :lecturer
  FLAG_ICONS = {"badquality"=>"fa fa-flag","goodquality"=>"fa fa-flag", "delete"=>"fa fa-trash"}
 FLAG_CONFIRM={}
  scope :not_flag_badquality, ->{where("flag_badquality IS NULL OR flag_badquality=?",false)}
 scope :flag_badquality, ->{where("flag_badquality=?",true)}
  scope :not_flag_delete, ->{where("flag_delete IS NULL OR flag_delete=?",false)}
 scope :flag_delete, ->{where("flag_delete=?",true)}
  
 mount_uploader :beispieldatei, AttachmentUploader

  include IsCommentable

  validates :beispieldatei, :presence => true
  validates :name, :presence => true
  validates :lva_id, :presence => true
  validates :lva, :presence => true
  validates :datum, :presence => true
   def to_jq_upload
  {
    "id" => read_attribute(:id),
    "title" => read_attribute(:title),
    "description" => read_attribute(:desc),
    "name" => read_attribute(:title),
    "size" => beispieldatei.size,
    "url" => beispieldatei.url,
    "thumbnail_url" => beispieldatei.thumb.url,
    "delete_type" => "DELETE" 
   }
end
   def divid
     "beispiel_"+id.to_s
   end
end
