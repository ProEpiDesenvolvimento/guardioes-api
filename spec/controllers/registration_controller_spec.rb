require 'rails_helper'

RSpec.describe RegistrationController, type: :controller do
  login_admin

  let(:valid_attributes) {
    {
      current_admin: {
        is_god: false
      },
      admin: {
        is_god: true
      }
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  it "ensure method has a current_admin" do

    expect(subject.current_admin).to_not eq(nil)
  end

  it "ensure current_admin is god" do

    expect(subject.current_admin.is_god).to_not eq(nil)
  end


  it "returns ok response to valid request" do

    post :create_admin, params: valid_attributes, session: valid_session
    expect(response).to have_http_status(:ok)
  end
end