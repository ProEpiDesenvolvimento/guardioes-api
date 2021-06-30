require "rails_helper"

RSpec.describe FormOptionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/form_options").to route_to("form_options#index")
    end

    it "routes to #show" do
      expect(:get => "/form_options/1").to route_to("form_options#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/form_options").to route_to("form_options#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/form_options/1").to route_to("form_options#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/form_options/1").to route_to("form_options#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/form_options/1").to route_to("form_options#destroy", :id => "1")
    end
  end
end
