class CityManagersController < ApplicationController
  before_action :authenticate_admin!, only: [:index]
  before_action :set_app, only: [:index]
  before_action :set_city_manager, only: [:show, :update, :destroy]

  load_and_authorize_resource :except => [:email_reset_password, :reset_password, :show_reset_token]

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
    if current_city_manager
      has_updated = @city_manager.update(city_manager_update_params)
    else
      has_updated = @city_manager.update(city_manager_params)
    end

    if has_updated
      render json: @city_manager
    else
      render json: @city_manager.errors, status: :unprocessable_entity
    end
  end

  # DELETE /city_managers/1
  def destroy
    @city_manager.destroy!
  end

  def email_reset_password
    @city_manager = CityManager.find_by_email(params[:email])
    aux_code = rand(36**4).to_s(36)
    reset_password_token = rand(36**10).to_s(36)
    @city_manager.update_attribute(:aux_code, aux_code)
    @city_manager.update_attribute(:reset_password_token, reset_password_token)
    if @city_manager.present?
      CityManagerMailer.reset_password_email(@city_manager).deliver
    end
    render json: {message: "Email enviado com sucesso"}, status: :ok
  end

  def show_reset_token
    city_manager = CityManager.where(aux_code: params[:code]).first
    if city_manager.present?
      render json: {reset_password_token: city_manager.reset_password_token}, status: :ok
    else
      render json: {error: true, message: "Codigo invalido"}, status: :bad_request
    end
  end

  def reset_password
    @city_manager = CityManager.where(reset_password_token: params[:reset_password_token]).first
    if @city_manager.present?
      if @city_manager.reset_password(params[:password], params[:password_confirmation])
        render json: {error: false, message: "Senha redefinida com sucesso"}, status: :ok
      else
        render json: {error: true, data: @city_manager.errors}, status: :bad_request
      end
    else
      render json: {error: true, message: "Token invalido"}, status: :bad_request
    end
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
    def city_manager_update_params
      params.require(:city_manager).permit(
        :name,
        :email,
        :password,
        :app_id
      )
    end
end
