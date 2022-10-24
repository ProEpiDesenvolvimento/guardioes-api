require 'rails_helper'

RSpec.describe "VbeForms", type: :request do
  describe "GET /vbe_forms" do
    it "works! (now write some real specs)" do
      get vbe_forms_path
      expect(response).to have_http_status(200)
    end
  end
end
