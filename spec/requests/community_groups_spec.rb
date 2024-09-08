require 'rails_helper'

RSpec.describe "CommunityGroups", type: :request do
  describe "GET /community_groups" do
    it "works! (now write some real specs)" do
      get community_groups_path
      expect(response).to have_http_status(401)
    end
  end
end
