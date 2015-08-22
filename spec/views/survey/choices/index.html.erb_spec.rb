require 'rails_helper'

RSpec.describe "survey/choices/index", :type => :view do
  before(:each) do
    assign(:survey_choices, [
      Survey::Choice.create!(
        :text => "Text",
        :question => nil,
        :sort => 1,
        :picture => "Picture"
      ),
      Survey::Choice.create!(
        :text => "Text",
        :question => nil,
        :sort => 1,
        :picture => "Picture"
      )
    ])
  end

  it "renders a list of survey/choices" do
    render
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Picture".to_s, :count => 2
  end
end
