require "rails_helper"

RSpec.describe FormsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/forms").to route_to("forms#index")
    end

    it "routes to #show" do
      expect(:get => "/forms/1").to route_to("forms#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/forms").to route_to("forms#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/forms/1").to route_to("forms#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/forms/1").to route_to("forms#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/forms/1").to route_to("forms#destroy", :id => "1")
    end
  end
end
