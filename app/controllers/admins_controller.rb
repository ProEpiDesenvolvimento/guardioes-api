class AdminsController < ApplicationController
  before_action :authenticate_admin!, except: [:email_reset_password, :reset_password, :show_reset_token] 

  load_and_authorize_resource
  
  def index
    @admins = Admin.all
    render json: @admins
  end
  
  def update
    errors = {}
    @admin = Admin.find(params[:id])
    begin
    	@admin.update!(admin_params)
    rescue StandardError => e
    	errors << e
    end
    if errors.length == 0
      render json: @admin
    else
      render json: {errors: errors, user: @admin}, status: :unprocessable_entity
    end
  end

  def destroy
    errors = {}
    @admin = Admin.find(params[:id])
    begin
      @admin.destroy!
    rescue StandardError => e
      errors << e
    end
  end

  def email_reset_password
    @admin = Admin.find_by_email(params[:email])
    aux_code = rand(36**4).to_s(36)
    reset_password_token = rand(36**10).to_s(36)
    @admin.update_attribute(:aux_code, aux_code)
    @admin.update_attribute(:reset_password_token, reset_password_token)
    if @admin.present?
      AdminMailer.reset_password_email(@admin).deliver
    end
    render json: {message: "Email enviado com sucesso"}, status: :ok
  end

  def show_reset_token
    admin = Admin.where(aux_code: params[:code]).first
    if admin.present?
      render json: {reset_password_token: admin.reset_password_token}, status: :ok
    else
      render json: {error: true, message: "Codigo invalido"}, status: :bad_request
    end
  end

  def reset_password
    @admin = Admin.where(reset_password_token: params[:reset_password_token]).first
    if @admin.present?
      if @admin.reset_password(params[:password], params[:password_confirmation])
        render json: {error: false, message: "Senha redefinida com sucesso"}, status: :ok
      else
        render json: {error: true, data: @admin.errors}, status: :bad_request
      end
    else
      render json: {error: true, message: "Token invalido"}, status: :bad_request
    end
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
