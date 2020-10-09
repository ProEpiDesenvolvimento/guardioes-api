class Managers < ApplicationController

  def index
    render json: @app.group_managers
  end

  private
  def manager_params
    params.require(:manager).permit(
        :name
        :email,
        :password,
      )
  end 
end