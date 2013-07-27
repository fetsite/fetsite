require 'spec_helper'

describe Modulgruppe do
  it "modulgruppe should not be valid without studium" do
  mg=FactoryGirl.build(:modulgruppe)
  mg.should_not be_valid
  mg.should have(1).errors_on(:studium_id)
  end 
  it "modulgruppe should be valid with studium" do
  s=FactoryGirl.create(:studium)
  mg=FactoryGirl.build(:modulgruppe)
  mg.studium=s
  mg.should be_valid
  end   
  
end
