require "rails_helper"

RSpec.describe CommunityGroupsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/community_groups").to route_to("community_groups#index")
    end

    it "routes to #show" do
      expect(:get => "/community_groups/1").to route_to("community_groups#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/community_groups").to route_to("community_groups#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/community_groups/1").to route_to("community_groups#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/community_groups/1").to route_to("community_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/community_groups/1").to route_to("community_groups#destroy", :id => "1")
    end
  end
end
