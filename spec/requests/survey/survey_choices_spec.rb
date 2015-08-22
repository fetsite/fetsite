require 'rails_helper'

RSpec.describe "Survey::Choices", :type => :request do
  describe "GET /survey_choices" do
    it "works! (now write some real specs)" do
      get survey_choices_path
      expect(response).to have_http_status(200)
    end
  end
end
