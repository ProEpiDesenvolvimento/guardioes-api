require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let(:valid_session) { {} }
  login_group_manager

  before :each do
    @file = fixture_file_upload('../fixtures/file.xls', 'application/vnd.ms-excel')
  end
  describe 'POST groups#updload_group_file' do
    it "creates groups" do
      post :upload_group_file, params: { file: @file, build_country_city_state_model: true }, session: valid_session
      expect(response).to have_http_status(:created)
    end
  end
end
