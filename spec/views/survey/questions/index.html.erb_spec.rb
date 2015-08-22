require 'rails_helper'

RSpec.describe "survey/questions/index", :type => :view do
  before(:each) do
    assign(:survey_questions, [
      Survey::Question.create!(
        :title => "Title",
        :text => "MyText",
        :typ => 1
      ),
      Survey::Question.create!(
        :title => "Title",
        :text => "MyText",
        :typ => 1
      )
    ])
  end

  it "renders a list of survey/questions" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
