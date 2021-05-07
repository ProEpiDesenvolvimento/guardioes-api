require 'rails_helper'

RSpec.describe "FormAnswers", type: :request do
  describe "GET /form_answers" do
    it "works! (now write some real specs)" do
      get form_answers_path
      expect(response).to have_http_status(200)
    end
  end
end
