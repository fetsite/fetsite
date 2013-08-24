# == Schema Information
#
# Table name: themengruppen
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Themengruppe < ActiveRecord::Base
  WORD_COUNT = 50
  attr_accessible :text, :title, :picture
  has_many :themen, class_name: 'Thema'
  has_many :fragen, through: :themen
  mount_uploader :picture, PictureUploader
  
  validates :title, :presence => true

  translates :title,:text, :versioning =>true, :fallbacks_for_empty_translations => true
end
