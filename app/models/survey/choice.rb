class Survey::Choice < ActiveRecord::Base
  belongs_to :question, class_name: 'Survey::Question'
  attr_accessible :picture, :sort, :text, :icon, :picture_cache, :remove_picture, :question_id
  has_many :answers, class_name: 'Survey::Answer', dependent: :destroy
  include ActionView::Helpers::TagHelper
  mount_uploader :picture, PictureUploader
  def to_s
    self.text
  end
  def html
    content_tag("i","", class: self.icon ) + self.text
  end
  def attributes_for_copy
    self.attributes.select{|k,v| ["text","sort", "picture", "icon"].include?(k)}
  end
  def copy_from_template
    cpy = Survey::Choice.new(self.attributes_for_copy)
    cpy.save
    cpy
  end
end
