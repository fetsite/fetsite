class Survey::Choice < ActiveRecord::Base
  belongs_to :question, class_name: 'Survey::Question'
  attr_accessible :picture, :sort, :text
  has_many :answers, class_name: 'Survey::Answer'
  def to_s
    self.text
  end
end
