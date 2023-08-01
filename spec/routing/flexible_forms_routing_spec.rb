require "rails_helper"

RSpec.describe FlexibleFormsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/flexible_forms").to route_to("flexible_forms#index")
    end

    it "routes to #show" do
      expect(:get => "/flexible_forms/1").to route_to("flexible_forms#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/flexible_forms").to route_to("flexible_forms#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/flexible_forms/1").to route_to("flexible_forms#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/flexible_forms/1").to route_to("flexible_forms#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/flexible_forms/1").to route_to("flexible_forms#destroy", :id => "1")
    end
  end
end
