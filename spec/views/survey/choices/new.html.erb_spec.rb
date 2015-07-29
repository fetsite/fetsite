require 'rails_helper'

RSpec.describe "survey/choices/new", :type => :view do
  before(:each) do
    assign(:survey_choice, Survey::Choice.new(
      :text => "MyString",
      :question => nil,
      :sort => 1,
      :picture => "MyString"
    ))
  end

  it "renders new survey_choice form" do
    render

    assert_select "form[action=?][method=?]", survey_choices_path, "post" do

      assert_select "input#survey_choice_text[name=?]", "survey_choice[text]"

      assert_select "input#survey_choice_question[name=?]", "survey_choice[question]"

      assert_select "input#survey_choice_sort[name=?]", "survey_choice[sort]"

      assert_select "input#survey_choice_picture[name=?]", "survey_choice[picture]"
    end
  end
end
