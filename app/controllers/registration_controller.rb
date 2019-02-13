class RegistrationController < Devise::RegistrationsController
    respond_to :json

    def create
        build_resource(sign_up_params)
        resource.save

        render_resource(resource)
    end

    private
    def sign_up_params
        params.require(:admin).permit(
            :email, 
            :password, 
            :first_name, 
            :last_name,
            :is_god
        )
    end
end
