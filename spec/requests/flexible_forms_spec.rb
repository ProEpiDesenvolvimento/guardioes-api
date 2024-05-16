require 'rails_helper'

RSpec.describe "FlexibleForms", type: :request do
  describe "GET /flexible_forms" do
    it "works! (now write some real specs)" do
      get flexible_forms_path
      expect(response).to have_http_status(200)
    end
  end
end
