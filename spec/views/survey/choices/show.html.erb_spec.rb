require 'rails_helper'

RSpec.describe "survey/choices/show", :type => :view do
  before(:each) do
    @survey_choice = assign(:survey_choice, Survey::Choice.create!(
      :text => "Text",
      :question => nil,
      :sort => 1,
      :picture => "Picture"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Text/)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Picture/)
  end
end
