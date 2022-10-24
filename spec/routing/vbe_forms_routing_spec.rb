require "rails_helper"

RSpec.describe VbeFormsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/vbe_forms").to route_to("vbe_forms#index")
    end

    it "routes to #show" do
      expect(:get => "/vbe_forms/1").to route_to("vbe_forms#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/vbe_forms").to route_to("vbe_forms#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/vbe_forms/1").to route_to("vbe_forms#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/vbe_forms/1").to route_to("vbe_forms#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/vbe_forms/1").to route_to("vbe_forms#destroy", :id => "1")
    end
  end
end
