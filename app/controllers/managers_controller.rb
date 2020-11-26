class ManagersController < ApplicationController
  before_action :authenticate_admin!, only: [:index]
  before_action :set_manager, only: [:show, :update, :destroy]
  before_action :set_app, only: [:index]

  load_and_authorize_resource

  def index
    if @app.managers.empty?
      return render json: @app.managers, status: :ok
    end
    data = { 'managers' => [] }
    @app.managers.each do |manager|
      permissions = Permission.where(manager_id: manager.id).first
      data['managers'].append({manager: manager}.merge({permissions: permissions}))
    end
    render json: data, status: :ok
  end

  # GET /managers/:id
  def show
    @manager = Manager.find(params[:id])
    @permissions = Permission.where(manager_id: @manager.id) 
    data = {manager: @manager}.merge({permissions: @permissions})
    render json: data, status: :ok
  end

  def update
    if @manager.update(manager_params.except(:permissions))
      @permission = Permission.where(manager_id: @manager.id).first
      if params['manager'].has_key?(:permissions)
        if @permission.update({models_manage: manager_params.fetch(:permissions)})
          data = {manager: @manager}.merge({permissions: @permission})
          render json: data, status: :ok
        else
          render json: @permission.errors, status: :unprocessable_entity
        end
      else
        render json: "aaaa"
      end
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
        :permissions => []
      )
  end 
end