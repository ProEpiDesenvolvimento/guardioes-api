require "rails_helper"

RSpec.describe AppsController, type: :controller do
  let(:valid_access_apps_token) {
    skip("Add a hash of valid access apps token for your model")
  }

  let(:invalid_access_apps_token) {
    skip("Add a hash of invalid access apps token for your model")
  }

  let(:valid_admin_token) {
    skip("Add a hash of signed in admin for your model")
  }

  let(:invalid_admin_token) {
    skip("Add a hash of not signed in admin for your model")
  }

  let(:valid_attributes) {
    skip("Add a hash of signed in admin for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of signed in admin for your model")
  }

  let(:invalid_admin_token) {
    skip("Add a hash of not signed in admin for your model")
  }

  let(:valid_session) { {} }

  describe "POST #create" do
    context "when access_apps_token is valid" do
      it "(CT1) renders a JSON response with success" do
        post :create, params: {access_apps_token: valid_access_apps_token, user_token: valid_admin_token, apps: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end

      it "(CT2) renders a JSON response with success" do
        post :create, params: {access_apps_token: valid_access_apps_token, user_token: invalid_admin_token, apps: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "when admin is signed in" do
      it "(CT3) renders a JSON response with 422 error" do
        post :create, params: {access_apps_token: invalid_access_apps_token, user_token: valid_admin_token, apps: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end

      it "(CT3) renders a JSON response with 404 error" do
        post :create, params: {access_apps_token: invalid_access_apps_token, user_token: valid_admin_token, apps: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json')
      end
    end


  end
end
