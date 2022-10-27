require "rails_helper"

RSpec.describe VbeAnswersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/vbe_answers").to route_to("vbe_answers#index")
    end

    it "routes to #show" do
      expect(:get => "/vbe_answers/1").to route_to("vbe_answers#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/vbe_answers").to route_to("vbe_answers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/vbe_answers/1").to route_to("vbe_answers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/vbe_answers/1").to route_to("vbe_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/vbe_answers/1").to route_to("vbe_answers#destroy", :id => "1")
    end
  end
end
