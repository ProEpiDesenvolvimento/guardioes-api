require 'rails_helper'

RSpec.describe "CityManagers", type: :request do
  describe "GET /city_managers" do
    it "works! (now write some real specs)" do
      get city_managers_path
      expect(response).to have_http_status(200)
    end
  end
end
