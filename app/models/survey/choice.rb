class Survey::Choice < ActiveRecord::Base
  belongs_to :question, class_name: 'Survey::Question'
  attr_accessible :picture, :sort, :text, :icon, :picture_cache
  has_many :answers, class_name: 'Survey::Answer'
  include ActionView::Helpers::TagHelper
  mount_uploader :picture, PictureUploader
  def to_s
       self.text
  end
  def html
       content_tag("i","", class: self.icon ) + self.text
  end
end
