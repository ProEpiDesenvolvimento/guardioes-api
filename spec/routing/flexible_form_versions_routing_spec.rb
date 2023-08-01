require "rails_helper"

RSpec.describe FlexibleFormVersionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/flexible_form_versions").to route_to("flexible_form_versions#index")
    end

    it "routes to #show" do
      expect(:get => "/flexible_form_versions/1").to route_to("flexible_form_versions#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/flexible_form_versions").to route_to("flexible_form_versions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/flexible_form_versions/1").to route_to("flexible_form_versions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/flexible_form_versions/1").to route_to("flexible_form_versions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/flexible_form_versions/1").to route_to("flexible_form_versions#destroy", :id => "1")
    end
  end
end
