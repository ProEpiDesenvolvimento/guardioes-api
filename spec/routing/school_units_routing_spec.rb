require "rails_helper"

RSpec.describe SchoolUnitsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/school_units").to route_to("school_units#index")
    end

    it "routes to #show" do
      expect(:get => "/school_units/1").to route_to("school_units#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/school_units").to route_to("school_units#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/school_units/1").to route_to("school_units#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/school_units/1").to route_to("school_units#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/school_units/1").to route_to("school_units#destroy", :id => "1")
    end
  end
end
