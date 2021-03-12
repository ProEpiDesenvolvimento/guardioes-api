class ApplicationController < ActionController::API
  # before_action :ensure_json_request
  # protect_from_forgery
  include ActionController::MimeResponds
  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :unauthorized
  end

  def ensure_json_request
      return if request.headers["Accept"] =~ /vnd\.api\+json/
      render :nothing => true, :status => 406
  end

  # methods used on Admin and User registration
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: I18n.translate("validations.title"),
          detail: resource.errors,
          code: resource
        }
      ]
    }, status: :bad_request
  end

  def current_ability
      if admin_signed_in?
        @current_ability ||= Ability.new(current_admin)
      elsif manager_signed_in?
        @current_ability ||= Ability.new(current_manager)
      elsif city_manager_signed_in?
        @current_ability ||= Ability.new(current_city_manager)
      elsif group_manager_signed_in?
        @current_ability ||= Ability.new(current_group_manager)
      else
        @current_ability ||= Ability.new(current_user)
      end
  end
end
