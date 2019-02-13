class RegistrationController < Devise::RegistrationsController
    respond_to :json

    def create
        build_resource(sign_up_params)
        resource.save

        render_resource(resource)
    end

    private
    def sign_up_params
        params.permit(
            :email, 
            :user_name,
            :birthdate,
            :country,
            :gender,
            :race,
            :is_professional,
            :password, 
            :first_name, 
            :last_name,
            :is_god
        )
    end
end
