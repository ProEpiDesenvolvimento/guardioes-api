class RegistrationController < Devise::RegistrationsController
  respond_to :json
  
  def create
    # app = App.where(id: sign_up_params[:app_id]) ? App.find(sign_up_params[:app_id]) : nil
    
    
    if params[:user] && App.where(id: sign_up_params[:app_id]).exists?
      create_an_app(sign_up_params.country, sign_up_params.country)

      new_params = sign_up_params.merge(app_id: App.last.id)
      puts "\n\n\n\n\n\n\n\n #{new_params} \n\n\n\n\n\n\n\n"
      build_resource(new_params)
      resource.save
  
      render_resource(resource)
    else
      build_resource(sign_up_params)
      resource.save
  
      render_resource(resource)
    end
  end

  private

  def create_an_app(app_name, owner_country)
    App.create(
      app_name: "#{app_name}",
      owner_country: "#{owner_country}"
    )
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
