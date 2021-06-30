require 'rails_helper'

RSpec.describe "FormOptions", type: :request do
  describe "GET /form_options" do
    it "works! (now write some real specs)" do
      get form_options_path
      expect(response).to have_http_status(200)
    end
  end
end
