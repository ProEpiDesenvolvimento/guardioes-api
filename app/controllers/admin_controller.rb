class AdminController < ApplicationController
  before_action :authenticate_admin!
  def index
    @admins = Admin.all
    render json: @admins
  end

  private
  def admin_params
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

