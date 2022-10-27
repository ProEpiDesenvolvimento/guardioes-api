require 'rails_helper'

RSpec.describe "VbeAnswers", type: :request do
  describe "GET /vbe_answers" do
    it "works! (now write some real specs)" do
      get vbe_answers_path
      expect(response).to have_http_status(200)
    end
  end
end
