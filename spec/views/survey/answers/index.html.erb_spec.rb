require 'rails_helper'

RSpec.describe "survey/answers/index", :type => :view do
  before(:each) do
    assign(:survey_answers, [
      Survey::Answer.create!(
        :choice => nil,
        :user => nil
      ),
      Survey::Answer.create!(
        :choice => nil,
        :user => nil
      )
    ])
  end

  it "renders a list of survey/answers" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
