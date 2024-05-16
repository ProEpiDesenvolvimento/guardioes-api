require 'rails_helper'

RSpec.describe "FlexibleFormVersions", type: :request do
  describe "GET /flexible_form_versions" do
    before do
      user = FactoryBot.create(:user)
      sign_in user
    end
    it "works! (now write some real specs)" do
      get flexible_form_versions_path
      expect(response).to have_http_status(200)
    end
  end
end
