require "rails_helper"

RSpec.describe FlexibleAnswersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/flexible_answers").to route_to("flexible_answers#index")
    end

    it "routes to #show" do
      expect(:get => "/flexible_answers/1").to route_to("flexible_answers#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/flexible_answers").to route_to("flexible_answers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/flexible_answers/1").to route_to("flexible_answers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/flexible_answers/1").to route_to("flexible_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/flexible_answers/1").to route_to("flexible_answers#destroy", :id => "1")
    end
  end
end
