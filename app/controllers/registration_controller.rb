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
    if params[:user]
      if params[:user][:residence].blank?
        find_app = App.where(owner_country: params[:user][:country])
  
        if find_app.blank?
          name = params[:user][:country]
          app = App.create!(app_name: name, owner_country: name)
  
          puts "\n New Sign up Params App doesn't exist \n\n\n"
          puts @new_sign_up_params
          @new_sign_up_params = sign_up_params.merge(app_id: app.id).except(:residence)
          puts "\n\n\n"
        else
          puts "\n New Sign up Params App does exist \n\n\n"
          puts @new_sign_up_params
          @new_sign_up_params = sign_up_params.merge(app_id: find_app.first.id).except(:residence)
          puts "\n\n\n"
        end
      else
        find_app = App.where(owner_country: params[:user][:residence])
  
        if find_app.blank?
          name = params[:user][:residence]
          app = App.create!(app_name: name, owner_country: name)
  
          @new_sign_up_params = sign_up_params.merge(app_id: app.id).except(:residence)
        else
          @new_sign_up_params = sign_up_params.merge(app_id: find_app.first.id).except(:residence)
        end
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
