require 'rails_helper'

RSpec.describe 'guardians API', type: :request do
  # initialize test data
  let!(:apps) { create_list(:app, 10) }
  let(:app_id) { apps.first.id }

  # test suite for GET /apps
  describe 'GET /apps' do
    
    # make HTTP get request before each example
    before do
      user = create(:admin, app: apps.first )
      sign_in user    
      get '/apps', {}
    end

    it 'returns apps' do
      expect(response.body).not_to be_empty
      expect(JSON.parse(response.body).count).to eq(1) # should return the APP of the generated admin user 
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  # Test suite for GET /apps/:id
  # describe 'GET /apps/:id' do
  #   before { get "/apps/#{app_id}" }

  #   context 'when the record exists' do
  #     it 'returns that app' do
  #       expect(json).not_to be_empty
  #       expect(json[app.id]).to eq(app_id)
  #     end

  #     it 'returns status 200' do
  #       expect(response).to have_http_status(200)
  #     end
  #   end

  #   context 'when the record does not exist' do
  #     let(:app_id) { 100 }

  #     it 'returns status code 404' do
  #       expect(response).to have_http_status(404)
  #     end

  #     it 'returns a not found message' do
  #       expect(response.body).to match("{\"message\":\"Couldn't find App with 'id'=100\"}")
  #     end
  #   end
  # end

  # Test suite for POST /article
  # describe 'POST /apps' do
  #   # valid payload
  #   let(:valid_attributes) { { app_name: "Dev test", owner_country: "Brazil" } }

  #   context 'when the request is valid' do
  #     before { post '/apps', params: valid_attributes }

  #     it 'creates an app' do
  #       expect(json['app_name']).to eq('Dev test')
  #       expect(json['owner_country']).to eq('Brazil')
  #     end

  #     it 'returns status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #   end

  #   context 'when the request is invalid' do
  #     before { post '/apps', params: { owner_country: 'Brazil' } }

  #     it 'returns status code 422' do
  #       expect(response).to have_http_status(422)
  #     end

  #     it 'returns a validation failure message' do
  #       expect(response.body)
  #         .to match("{\message\":\"Validation failed: App Name can't be blank\"}")
  #     end
  #   end
  # end
end