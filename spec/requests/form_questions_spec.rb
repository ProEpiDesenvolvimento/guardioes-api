require 'rails_helper'

RSpec.describe "FormQuestions", type: :request do
  describe "GET /form_questions" do
    it "when it doesn't have a token" do
      get form_questions_path
      expect(response).to have_http_status(401)
    end
  end
end
