require "rails_helper"

RSpec.describe EventAnswersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/event_answers").to route_to("event_answers#index")
    end

    it "routes to #show" do
      expect(:get => "/event_answers/1").to route_to("event_answers#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/event_answers").to route_to("event_answers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/event_answers/1").to route_to("event_answers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/event_answers/1").to route_to("event_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/event_answers/1").to route_to("event_answers#destroy", :id => "1")
    end
  end
end
