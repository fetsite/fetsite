require "rails_helper"

RSpec.describe Survey::ChoicesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/survey/choices").to route_to("survey/choices#index")
    end

    it "routes to #new" do
      expect(:get => "/survey/choices/new").to route_to("survey/choices#new")
    end

    it "routes to #show" do
      expect(:get => "/survey/choices/1").to route_to("survey/choices#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/survey/choices/1/edit").to route_to("survey/choices#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/survey/choices").to route_to("survey/choices#create")
    end

    it "routes to #update" do
      expect(:put => "/survey/choices/1").to route_to("survey/choices#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/survey/choices/1").to route_to("survey/choices#destroy", :id => "1")
    end

  end
end
