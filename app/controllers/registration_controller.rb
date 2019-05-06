class RegistrationController < Devise::RegistrationsController
  respond_to :json
  
  def create
    build_resource(sign_up_params)
    resource.save

    render_resource(resource)
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
        :app_id
      )
    elsif params[:admin]
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
