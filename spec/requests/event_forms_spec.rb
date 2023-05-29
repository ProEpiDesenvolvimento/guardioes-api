require 'rails_helper'

RSpec.describe "EventForms", type: :request do
  describe "GET /event_forms" do
    it "works! (now write some real specs)" do
      get event_forms_path
      expect(response).to have_http_status(200)
    end
  end
end
