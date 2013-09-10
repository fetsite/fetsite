# == Schema Information
#
# Table name: galleries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  desc       :text
#  datum      :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Gallery < ActiveRecord::Base
  WORD_COUNT = 20
  attr_accessible :datum, :desc, :name
  has_many :fotos
end
