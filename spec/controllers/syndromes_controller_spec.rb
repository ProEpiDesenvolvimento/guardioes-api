require 'rails_helper'

RSpec.describe SyndromesController, type: :controller do
  login_admin

  it "should have a current_user" do
    # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_admin).to_not eq(nil)
  end

  # This should return the minimal set of attributes required to create a valid
  # Syndrome. As you add validations to Syndrome, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }


  describe "GET #index" do
    it "returns a success response" do
      syndrome = Syndrome.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      syndrome = Syndrome.create! valid_attributes
      get :show, params: {id: syndrome.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Syndrome" do
        expect {
          post :create, params: {syndrome: valid_attributes}, session: valid_session
        }.to change(Syndrome, :count).by(1)
      end

      it "renders a JSON response with the new syndrome" do

        post :create, params: {syndrome: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(syndrome_url(Syndrome.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new syndrome" do

        post :create, params: {syndrome: invalid_attributes}, session: valid_session
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

      it "updates the requested syndrome" do
        syndrome = Syndrome.create! valid_attributes
        put :update, params: {id: syndrome.to_param, syndrome: new_attributes}, session: valid_session
        syndrome.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the syndrome" do
        syndrome = Syndrome.create! valid_attributes

        put :update, params: {id: syndrome.to_param, syndrome: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the syndrome" do
        syndrome = Syndrome.create! valid_attributes

        put :update, params: {id: syndrome.to_param, syndrome: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested syndrome" do
      syndrome = Syndrome.create! valid_attributes
      expect {
        delete :destroy, params: {id: syndrome.to_param}, session: valid_session
      }.to change(Syndrome, :count).by(-1)
    end
  end

end
