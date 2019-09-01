class RegistrationController < Devise::RegistrationsController
  before_action :set_app, only: :create, if: -> { params[:user] }
  respond_to :json
  
  def create
    if params[:user]
      build_resource(@new_sign_up_params)
      resource.save
  
      render_resource(resource)
    else
      build_resource(@sign_up_params)
      resource.save
  
      render_resource(resource)
    end
  end

  private
  def sign_up_params
    if params[:user]
      params.require(:user).permit(
        :email,
        :user_name,
        :birthdate,
        :country,
        :gender,
        :race,
        :is_professional,
        :password,
        :residence,
        :app_id,
        :picture
      )
    else
      puts "\n\nCheguei aqui \n\n\n"
      params.require(:admin).permit(
        :email,
        :password,
        :first_name,
        :last_name,
        :is_god,
        :app_id
      )
    end
  end
end
