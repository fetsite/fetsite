class Themengruppe < ActiveRecord::Base
  WORD_COUNT = 50
  attr_accessible :text, :title
  has_many :themen, class_name: 'Thema'
  has_many :fragen, through: :themen
  
  validates :title, :presence => true

  translates :title,:text, :versioning =>true, :fallbacks_for_empty_translations => true
end
