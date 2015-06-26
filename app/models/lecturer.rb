# == Schema Information
#
# Table name: lecturers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  oid        :integer
#  picture    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Lecturer < ActiveRecord::Base
  attr_accessible :email, :name, :oid, :picture, :remove_picture, :picture_cache, :lva_ids, :link
  has_and_belongs_to_many :lvas
  has_many :beispiele
  mount_uploader :picture, PictureUploader
  resourcify

  def load_tissdata
    url= "https://tiss.tuwien.ac.at/adressbuch/adressbuch/person_via_oid/"+self.oid.to_s+".xml"
    hash=Hash.from_xml(open(url).read)["tuvienna"]
    self.name=hash["person"]["firstname"]+" "+hash["person"]["lastname"]
    if hash["person"]["employee"]["employment"].is_a? Array
   self.email= hash["person"]["employee"]["employment"].first["emails"]["email"].first
    else
      self.email= hash["person"]["employee"]["employment"]["emails"]["email"].first
    end
    self.link= "https://tiss.tuwien.ac.at/adressbuch/adressbuch/person_via_oid/"+self.oid.to_s
  end
end
