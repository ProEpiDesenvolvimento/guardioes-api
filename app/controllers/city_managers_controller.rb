class CityManagersController < ApplicationController
  before_action :authenticate_admin!, only: [:index]
  before_action :set_app, only: [:index]
  before_action :set_city_manager, only: [:show, :update, :destroy]

  # GET /city_managers
  def index
    @city_managers = CityManager.all

    render json: @city_managers
  end

  # GET /city_managers/1
  def show
    render json: @city_manager
  end

  # PATCH/PUT /city_managers/1
  def update
    if @city_manager.update(city_manager_params)
      render json: @city_manager
    else
      render json: @city_manager.errors, status: :unprocessable_entity
    end
  end

  # DELETE /city_managers/1
  def destroy
    @city_manager.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city_manager
      @city_manager = CityManager.find(params[:id])
    end

    def set_app
      @app = App.find current_admin.app_id
    end

    # Only allow a trusted parameter "white list" through.
    def city_manager_params
      params.require(:city_manager).permit(
        :name,
        :email,
        :password,
        :city,
        :app_id
      )
    end
end
