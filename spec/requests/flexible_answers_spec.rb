require 'rails_helper'

RSpec.describe "FlexibleAnswers", type: :request do
  describe "GET /flexible_answers" do
    before do
      user = FactoryBot.create(:user)
      sign_in user
      stub_request(:get, /api-integracao/).
        to_return(status: 200, body: { '_embedded' => { 'signals' => [] } }.to_json, headers: { 'Content-Type' => 'application/json' })
    end
    it "works! (now write some real specs)" do
      get flexible_answers_path
      expect(response).to have_http_status(200)
    end
  end
end
