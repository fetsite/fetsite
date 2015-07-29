class Survey::Choice < ActiveRecord::Base
  belongs_to :question, class_name: 'Survey::Question'
  attr_accessible :picture, :sort, :text
  has_many :answers, class_name: 'Survey::Answer'
end
