require "rails_helper"

RSpec.describe CityManagersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/city_managers").to route_to("city_managers#index")
    end

    it "routes to #show" do
      expect(:get => "/city_managers/1").to route_to("city_managers#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/city_managers").to route_to("city_managers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/city_managers/1").to route_to("city_managers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/city_managers/1").to route_to("city_managers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/city_managers/1").to route_to("city_managers#destroy", :id => "1")
    end
  end
end
