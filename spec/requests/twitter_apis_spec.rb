require 'rails_helper'

RSpec.describe "TwitterApis", type: :request do
  describe "GET /twitter_apis" do
    it "works! (now write some real specs)" do
      get twitter_apis_path
      expect(response).to have_http_status(200)
    end
  end
end
