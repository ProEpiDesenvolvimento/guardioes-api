require 'rails_helper'

RSpec.describe "SchoolUnits", type: :request do
  describe "GET /school_units" do
    it "works! (now write some real specs)" do
      get school_units_path
      expect(response).to have_http_status(200)
    end
  end
end
