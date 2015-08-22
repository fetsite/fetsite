class Survey::Answer < ActiveRecord::Base
  belongs_to :choice, class_name: 'Survey::Choice'
  belongs_to :user
  # attr_accessible :title, :body
end
