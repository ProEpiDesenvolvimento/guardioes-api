require 'rails_helper'

RSpec.describe "CityManagers", type: :request do
  describe "GET /city_managers" do
    it "when it doesn't have a token" do
      get city_managers_path
      expect(response).to have_http_status(401)
    end
  end
end
