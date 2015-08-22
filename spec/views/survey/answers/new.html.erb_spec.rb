require 'rails_helper'

RSpec.describe "survey/answers/new", :type => :view do
  before(:each) do
    assign(:survey_answer, Survey::Answer.new(
      :choice => nil,
      :user => nil
    ))
  end

  it "renders new survey_answer form" do
    render

    assert_select "form[action=?][method=?]", survey_answers_path, "post" do

      assert_select "input#survey_answer_choice[name=?]", "survey_answer[choice]"

      assert_select "input#survey_answer_user[name=?]", "survey_answer[user]"
    end
  end
end
