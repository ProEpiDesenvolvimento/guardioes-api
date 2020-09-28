require "rails_helper"

RSpec.describe TwitterApisController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/twitter_apis").to route_to("twitter_apis#index")
    end

    it "routes to #show" do
      expect(:get => "/twitter_apis/1").to route_to("twitter_apis#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/twitter_apis").to route_to("twitter_apis#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/twitter_apis/1").to route_to("twitter_apis#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/twitter_apis/1").to route_to("twitter_apis#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/twitter_apis/1").to route_to("twitter_apis#destroy", :id => "1")
    end
  end
end
