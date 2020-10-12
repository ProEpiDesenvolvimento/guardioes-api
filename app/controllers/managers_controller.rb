class Managers < ApplicationController
  before_action :authenticate_admin!, only: [:index]
  before_action :set_manager, only: [:show, :update, :destroy]
  before_action :set_app, only: [:index]

  def index
    render json: @app.manager
  end

  # GET /managers/:id
  def show
    render json: @manager
  end

  private

  def set_manager
    @manager = Manager.find(params[:id])
  end

  def set_app
    @app = App.find current_admin.app_id
  end

  def manager_params
    params.require(:manager).permit(
        :name,
        :email,
        :password,
      )
  end 
end