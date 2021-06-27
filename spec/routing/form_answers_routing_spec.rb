require "rails_helper"

RSpec.describe FormAnswersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/form_answers").to route_to("form_answers#index")
    end

    it "routes to #show" do
      expect(:get => "/form_answers/1").to route_to("form_answers#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/form_answers").to route_to("form_answers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/form_answers/1").to route_to("form_answers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/form_answers/1").to route_to("form_answers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/form_answers/1").to route_to("form_answers#destroy", :id => "1")
    end
  end
end
