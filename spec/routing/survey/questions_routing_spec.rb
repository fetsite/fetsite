require "rails_helper"

RSpec.describe Survey::QuestionsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/survey/questions").to route_to("survey/questions#index")
    end

    it "routes to #new" do
      expect(:get => "/survey/questions/new").to route_to("survey/questions#new")
    end

    it "routes to #show" do
      expect(:get => "/survey/questions/1").to route_to("survey/questions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/survey/questions/1/edit").to route_to("survey/questions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/survey/questions").to route_to("survey/questions#create")
    end

    it "routes to #update" do
      expect(:put => "/survey/questions/1").to route_to("survey/questions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/survey/questions/1").to route_to("survey/questions#destroy", :id => "1")
    end

  end
end
