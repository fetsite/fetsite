require "rails_helper"

RSpec.describe Survey::AnswersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/survey/answers").to route_to("survey/answers#index")
    end

    it "routes to #new" do
      expect(:get => "/survey/answers/new").to route_to("survey/answers#new")
    end

    it "routes to #show" do
      expect(:get => "/survey/answers/1").to route_to("survey/answers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/survey/answers/1/edit").to route_to("survey/answers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/survey/answers").to route_to("survey/answers#create")
    end

    it "routes to #update" do
      expect(:put => "/survey/answers/1").to route_to("survey/answers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/survey/answers/1").to route_to("survey/answers#destroy", :id => "1")
    end

  end
end
