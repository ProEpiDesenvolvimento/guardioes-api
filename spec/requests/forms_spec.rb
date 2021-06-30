require 'rails_helper'

RSpec.describe "Forms", type: :request do
  describe "GET /forms" do
    it "works! (now write some real specs)" do
      get forms_path
      expect(response).to have_http_status(200)
    end
  end
end
