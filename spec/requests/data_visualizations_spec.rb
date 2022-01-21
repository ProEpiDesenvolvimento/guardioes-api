require 'rails_helper'

RSpec.describe "DataVisualizations", type: :request do
  # initialize test data
  let!(:apps) { create_list(:app, 10) }

  describe "GET /data_visualization/users_count" do
    it "when users_count doesn't have a token" do
      get '/data_visualization/users_count', {}
      expect(response).to have_http_status(401)
    end

    it "returns correct users count" do
      admin = create(:admin, app: apps.first)
      sign_in admin
      users_count = User.count

      get '/data_visualization/users_count', {}
      expect(response).to have_http_status(200)
      expect(response.body).to eq(users_count.to_s)
    end
  end

  describe "GET /data_visualization/surveys_count" do
    it "when surveys_count doesn't have a token" do
      get '/data_visualization/surveys_count', {}
      expect(response).to have_http_status(401)
    end

    it "returns correct surveys count" do
      admin = create(:admin, app: apps.first)
      sign_in admin
      surveys_count = Survey.count

      get '/data_visualization/surveys_count', {}
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /data_visualization/asymptomatic_surveys_count" do
    it "when asymptomatic_surveys_count doesn't have a token" do
      get '/data_visualization/asymptomatic_surveys_count', {}
      expect(response).to have_http_status(401)
    end

    it "returns correct asymptomatic_surveys count" do
      admin = create(:admin, app: apps.first)
      sign_in admin
      asymptomatic_surveys_count = Survey.where(symptom:[]).count

      get '/data_visualization/asymptomatic_surveys_count', {}
      expect(response).to have_http_status(200)
      expect(response.body).to eq(asymptomatic_surveys_count.to_s)
    end    
  end

  describe "GET /data_visualization/symptomatic_surveys_count" do
    it "when symptomatic_surveys_count doesn't have a token" do
      get '/data_visualization/symptomatic_surveys_count', {}
      expect(response).to have_http_status(401)
    end

    it "returns correct symptomatic_surveys count" do
      admin = create(:admin, app: apps.first)
      sign_in admin
      symptomatic_surveys_count = Survey.where.not(symptom:[]).count

      get '/data_visualization/symptomatic_surveys_count', {}
      expect(response).to have_http_status(200)
      expect(response.body).to eq(symptomatic_surveys_count.to_s)
    end
  end

  describe "POST /data_visualization/metabase_urls" do
    it "when metabase_urls doesn't have a token and params" do
      post '/data_visualization/metabase_urls', {}
      expect(response).to have_http_status(422)
    end
  end
end
