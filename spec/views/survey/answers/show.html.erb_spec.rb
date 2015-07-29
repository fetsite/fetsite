require 'rails_helper'

RSpec.describe "survey/answers/show", :type => :view do
  before(:each) do
    @survey_answer = assign(:survey_answer, Survey::Answer.create!(
      :choice => nil,
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
