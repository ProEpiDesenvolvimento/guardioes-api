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
    @permissions = Permission.where(manager_id: @manager.id) 
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

  def email_reset_password
    @manager = Manager.find_by_email(params[:email])
    aux_code = rand(36**4).to_s(36)
    reset_password_token = rand(36**10).to_s(36)
    @manager.update_attribute(:aux_code, aux_code)
    @manager.update_attribute(:reset_password_token, reset_password_token)
    if @manager.present?
      ManagerMailer.reset_password_email(@manager).deliver
    end
    render json: {message: "Email enviado com sucesso"}, status: :ok
  end

  def show_reset_token
    manager = Manager.where(aux_code: params[:code]).first
    if manager.present?
      render json: {reset_password_token: manager.reset_password_token}, status: :ok
    else
      render json: {error: true, message: "Codigo invalido"}, status: :bad_request
    end
  end

  def reset_password
    @manager = Manager.where(reset_password_token: params[:reset_password_token]).first
    if @manager.present?
      if @manager.reset_password(params[:password], params[:password_confirmation])
        render json: {error: false, message: "Senha redefinida com sucesso"}, status: :ok
      else
        render json: {error: true, data: @manager.errors}, status: :bad_request
      end
    else
      render json: {error: true, message: "Token invalido"}, status: :bad_request
    end
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
        :permission_id,
      )
  end 
end