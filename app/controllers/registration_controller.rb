class RegistrationController < Devise::RegistrationsController
  before_action :set_app, only: :create
  respond_to :json
  
  def create
    build_resource(@new_sign_up_params)
    resource.save

    render_resource(resource)
  end

  private
  def set_app
    if params[:user][:residence].blank?
      find_app = App.where(app_name: params[:user][:country])

      if find_app.blank?
        name = params[:user][:country]
        app = App.create!(app_name: name, owner_country: name)

        @new_sign_up_params = sign_up_params.merge(app_id: app.id).except(:residence)
      else
        @new_sign_up_params = sign_up_params.merge(app_id: find_app.first.id).except(:residence)
      end
    else
      find_app = App.where(app_name: params[:user][:residence])

      if find_app.blank?
        name = params[:user][:residence]
        app = App.create!(app_name: name, owner_country: name)

        @new_sign_up_params = sign_up_params.merge(app_id: app.id).except(:residence)
      else
        @new_sign_up_params = sign_up_params.merge(app_id: find_app.first.id).except(:residence)
      end
    end
  end

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
