require 'rails_helper'

RSpec.describe "survey/questions/show", :type => :view do
  before(:each) do
    @survey_question = assign(:survey_question, Survey::Question.create!(
      :title => "Title",
      :text => "MyText",
      :typ => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
