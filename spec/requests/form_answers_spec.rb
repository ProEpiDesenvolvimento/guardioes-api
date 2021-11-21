require 'rails_helper'

RSpec.describe "FormAnswers", type: :request do
  describe "GET /form_answers" do
    it "when it doesn't have a token" do
      get form_answers_path
      expect(response).to have_http_status(401)
    end
  end
end
