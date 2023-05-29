require "rails_helper"

RSpec.describe EventFormsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/event_forms").to route_to("event_forms#index")
    end

    it "routes to #show" do
      expect(:get => "/event_forms/1").to route_to("event_forms#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/event_forms").to route_to("event_forms#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/event_forms/1").to route_to("event_forms#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/event_forms/1").to route_to("event_forms#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/event_forms/1").to route_to("event_forms#destroy", :id => "1")
    end
  end
end
