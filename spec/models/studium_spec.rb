require 'spec_helper'

describe Studium do
  [:name, :zahl].each do |attr|
	it "should not be valid without #{attr}" do
		s = FactoryGirl.build(:studium, attr=>nil)
		s.should_not be_valid
	end
  end
	it "should create studium with valid data" do
		s=FactoryGirl.build(:studium)
		lambda {
		s.save!}.should change {Studium.count()}.by(1)
	end
	it "should not accept double entrys" do
		FactoryGirl.create(:studium)
		s=FactoryGirl.build(:studium)
		s.should_not be_valid
		s.should have_at_least(1).error_on(:name)
		s.should have_at_least(1).error_on(:zahl)
	end
	it "should expect zahl to be 000.000" do
		s=FactoryGirl.build(:studium, :zahl=>"000000")
		s.should_not be_valid
		s.should have_at_least(1).error_on(:zahl)
	end
end
