require 'rails_helper'

RSpec.describe "EventAnswers", type: :request do
  describe "GET /event_answers" do
    it "works! (now write some real specs)" do
      get event_answers_path
      expect(response).to have_http_status(200)
    end
  end
end
