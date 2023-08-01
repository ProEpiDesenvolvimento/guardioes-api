require 'rails_helper'

RSpec.describe "FlexibleAnswers", type: :request do
  describe "GET /flexible_answers" do
    it "works! (now write some real specs)" do
      get flexible_answers_path
      expect(response).to have_http_status(200)
    end
  end
end
