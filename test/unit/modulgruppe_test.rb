require 'test_helper'

class ModulgruppeTest < ActiveSupport::TestCase
   test "should not be valid without name" do
     mg=Modulgruppe.new();
     mg.should_not be_valid;
   end
end
