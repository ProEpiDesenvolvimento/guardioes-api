require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:all) {
    # Register app
    @valid_app = App.new(
      :app_name=>"unb",
      :owner_country=>"brazil"
    )
    # Register admin
    @valid_admin = Admin.new(
        :email => "juse@gmail.com",
        :password => "12345678",
        :first_name => "clebe",
        :last_name => "clebe",
        :is_god => true,
        :app_id => 1
    )
    @valid_app.save()
    @valid_admin.save()
  }

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      :email => "vitin@gmail.com",
      :password => "12345678",
      :user_name => "vitor",
      :app_id => 1
    }
  }

  # let(:admin) {
    
  # }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_user_session) { {} }

  let(:valid_admin_session) {
    @controller = SessionController
    post :login, params: {admin: 
      { :email => @valid_admin.email, :password => @valid_admin.password } }
    puts "==========="
    puts response
    puts "==========="
    @controller = UsersController
    # {:Authorization => Admin.reload.api_token}
    return {}
  }


  describe "GET #index" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :index, params: {}, session: valid_admin_session
      expect(response).to be_successful
    end
  end

  # describe "GET #show" do
  #   it "returns a success response" do
  #     user = User.create! valid_attributes
  #     get :show, params: {id: user.to_param}, session: valid_session
  #     expect(response).to be_successful
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new User" do
  #       expect {
  #         post :create, params: {user: valid_attributes}, session: valid_session
  #       }.to change(User, :count).by(1)
  #     end

  #     it "renders a JSON response with the new user" do

  #       post :create, params: {user: valid_attributes}, session: valid_session
  #       expect(response).to have_http_status(:created)
  #       expect(response.content_type).to eq('application/json')
  #       expect(response.location).to eq(user_url(User.last))
  #     end
  #   end

  #   context "with invalid params" do
  #     it "renders a JSON response with errors for the new user" do

  #       post :create, params: {user: invalid_attributes}, session: valid_session
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to eq('application/json')
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested user" do
  #       user = User.create! valid_attributes
  #       put :update, params: {id: user.to_param, user: new_attributes}, session: valid_session
  #       user.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "renders a JSON response with the user" do
  #       user = User.create! valid_attributes

  #       put :update, params: {id: user.to_param, user: valid_attributes}, session: valid_session
  #       expect(response).to have_http_status(:ok)
  #       expect(response.content_type).to eq('application/json')
  #     end
  #   end

  #   context "with invalid params" do
  #     it "renders a JSON response with errors for the user" do
  #       user = User.create! valid_attributes

  #       put :update, params: {id: user.to_param, user: invalid_attributes}, session: valid_session
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to eq('application/json')
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested user" do
  #     user = User.create! valid_attributes
  #     expect {
  #       delete :destroy, params: {id: user.to_param}, session: valid_session
  #     }.to change(User, :count).by(-1)
  #   end
  # end

  # describe "password changer functionality" do
  #   context "valid input" do
  #     it "updates password" do
    
  #     end
  #   end
  #   context "invalid input" do
  #     it "does not update password" do
    
  #     end
  #   end
  # end
  # describe "forgotten password functionality" do
  #   context "valid input" do
  #     it "creates new password through forgotten password mailer" do
        
  #     end
  #   end
  #   context "invalid input" do
  #     it "tries to create new password without providing email" do
        
  #     end
  #   end
  # end

end
