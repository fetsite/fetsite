require 'rails_helper'

RSpec.describe "survey/answers/edit", :type => :view do
  before(:each) do
    @survey_answer = assign(:survey_answer, Survey::Answer.create!(
      :choice => nil,
      :user => nil
    ))
  end

  it "renders the edit survey_answer form" do
    render

    assert_select "form[action=?][method=?]", survey_answer_path(@survey_answer), "post" do

      assert_select "input#survey_answer_choice[name=?]", "survey_answer[choice]"

      assert_select "input#survey_answer_user[name=?]", "survey_answer[user]"
    end
  end
end
