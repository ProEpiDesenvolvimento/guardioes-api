require "rails_helper"

RSpec.describe FormQuestionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/form_questions").to route_to("form_questions#index")
    end

    it "routes to #show" do
      expect(:get => "/form_questions/1").to route_to("form_questions#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/form_questions").to route_to("form_questions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/form_questions/1").to route_to("form_questions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/form_questions/1").to route_to("form_questions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/form_questions/1").to route_to("form_questions#destroy", :id => "1")
    end
  end
end
