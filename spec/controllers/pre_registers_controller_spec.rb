require 'rails_helper'

RSpec.describe PreRegistersController, type: :controller do
  login_admin

  it "should have a current_user" do
    # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_admin).to_not eq(nil)
  end

  # This should return the minimal set of attributes required to create a valid
  # PreRegister. As you add validations to PreRegister, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PreRegistersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      pre_register = PreRegister.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      pre_register = PreRegister.create! valid_attributes
      get :show, params: {id: pre_register.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new PreRegister" do
        expect {
          post :create, params: {pre_register: valid_attributes}, session: valid_session
        }.to change(PreRegister, :count).by(1)
      end

      it "renders a JSON response with the new pre_register" do

        post :create, params: {pre_register: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(pre_register_url(PreRegister.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new pre_register" do

        post :create, params: {pre_register: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested pre_register" do
        pre_register = PreRegister.create! valid_attributes
        put :update, params: {id: pre_register.to_param, pre_register: new_attributes}, session: valid_session
        pre_register.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the pre_register" do
        pre_register = PreRegister.create! valid_attributes

        put :update, params: {id: pre_register.to_param, pre_register: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the pre_register" do
        pre_register = PreRegister.create! valid_attributes

        put :update, params: {id: pre_register.to_param, pre_register: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested pre_register" do
      pre_register = PreRegister.create! valid_attributes
      expect {
        delete :destroy, params: {id: pre_register.to_param}, session: valid_session
      }.to change(PreRegister, :count).by(-1)
    end
  end

end
