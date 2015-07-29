require 'rails_helper'

RSpec.describe "Survey::Questions", :type => :request do
  describe "GET /survey_questions" do
    it "works! (now write some real specs)" do
      get survey_questions_path
      expect(response).to have_http_status(200)
    end
  end
end
