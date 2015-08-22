require 'rails_helper'

RSpec.describe "survey/questions/edit", :type => :view do
  before(:each) do
    @survey_question = assign(:survey_question, Survey::Question.create!(
      :title => "MyString",
      :text => "MyText",
      :typ => 1
    ))
  end

  it "renders the edit survey_question form" do
    render

    assert_select "form[action=?][method=?]", survey_question_path(@survey_question), "post" do

      assert_select "input#survey_question_title[name=?]", "survey_question[title]"

      assert_select "textarea#survey_question_text[name=?]", "survey_question[text]"

      assert_select "input#survey_question_typ[name=?]", "survey_question[typ]"
    end
  end
end
