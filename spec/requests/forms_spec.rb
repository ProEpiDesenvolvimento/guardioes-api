require 'rails_helper'

RSpec.describe "Forms", type: :request do
  describe "GET /forms" do
    it "when it doesn't have a token" do
      get forms_path
      expect(response).to have_http_status(401)
    end
  end
end
