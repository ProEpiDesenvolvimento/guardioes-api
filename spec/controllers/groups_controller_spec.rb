require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'POST groups#upload_group_file with an unauthorized user' do
    let(:valid_session) { {} }
    login_admin

    before do
      @file = fixture_file_upload('../fixtures/proper_file.xls', 'application/vnd.ms-excel')
      post :upload_group_file, params: { file: @file, build_country_city_state_model: true }, session: valid_session
    end

    it 'returns a forbidden response' do
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST groups#upload_group_file with a invalid file' do
    let(:valid_session) { {} }
    login_group_manager
    before do
      @invalid = fixture_file_upload('../fixtures/invalid.xls', 'application/vnd.ms-excel')
      post :upload_group_file, params: { file: @invalid, build_country_city_state_model: true }, session: valid_session
    end

    it 'returns returns unprocessable status' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns expected response' do
      expect(JSON.parse(response.body)['message']).to eq('Mandatory table rows not found')
    end
  end

  describe 'POST groups#upload_group_file with proper file' do
    let(:valid_session) { {} }
    login_group_manager
    before do
      @file = fixture_file_upload('../fixtures/proper_file.xls', 'application/vnd.ms-excel')
      post :upload_group_file, params: { file: @file, build_country_city_state_model: true }, session: valid_session
    end

    it 'returns returns unprocessable status' do
      expect(response).to have_http_status(:created)
    end

    it 'returns expected response' do
      expect(JSON.parse(response.body)['message']).to eq('All groups created')
    end
  end

  describe 'POST groups#upload_group_file with invalid names' do
    let(:valid_session) { {} }
    login_group_manager
    before do
      @file = fixture_file_upload('../fixtures/root_node.xls', 'application/vnd.ms-excel')
      post :upload_group_file, params: { file: @file, build_country_city_state_model: true }, session: valid_session
    end

    it 'returns returns unprocessable status' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns expected response' do
      expect(JSON.parse(response.body)['message']).to eq('You cannot name a group \'root_node\'')
    end
  end

  describe 'POST groups#updload_group_file with invalid row' do
    let(:valid_session) { {} }
    login_group_manager

    before do
      @file = fixture_file_upload('../fixtures/invalid_row_file.xls', 'application/vnd.ms-excel')
      post :upload_group_file, params: { file: @file, build_country_city_state_model: true }, session: valid_session
    end

    it 'returns a created response' do
      expect(response).to have_http_status(:created)
    end

    it 'returns a proper json' do
      expect(JSON.parse(response.body)['message']).to eq('Some or all groups were not created')
    end
  end
end
