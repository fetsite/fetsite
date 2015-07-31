class Survey::Choice < ActiveRecord::Base
  belongs_to :question, class_name: 'Survey::Question'
  attr_accessible :picture, :sort, :text
  has_many :answers, class_name: 'Survey::Answer'
  include ActionView::Helpers::TagHelper
  def to_s
       self.text
  end
  def html
       content_tag("i","", class: self.picture ) + self.text
  end
end
