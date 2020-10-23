class ManagersController < ApplicationController
  before_action :authenticate_admin!, only: [:index]
  before_action :set_manager, only: [:show, :update, :destroy]
  before_action :set_app, only: [:index]

  def index
    render json: @app.managers
  end

  # GET /managers/:id
  def show
    @manager = Manager.find(params[:id])
    @permissions = Permission.find(@manager.permission_id) 
    data = {manager: @manager}.merge({permisions: @permissions})
    render json: data, status: :ok
  end

  def update
    if @manager.update(manager_params)
      render json: @manager
    else
      render json: @manager.errors, status: :unprocessable_entity
    end
  end

  # DELETE /managers/:id
  def destroy
    @manager.destroy!
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