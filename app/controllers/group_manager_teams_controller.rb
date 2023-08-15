class GroupManagerTeamsController < ApplicationController
  # before_action :set_app, only: [:index]
  before_action :set_group_manager_team, only: [:show, :update, :destroy]

  load_and_authorize_resource :except => [:email_reset_password, :reset_password, :show_reset_token]

  # GET /group_manager_teams
  def index
    if current_group_manager
      @user = current_group_manager
      @group_manager_teams = GroupManagerTeam.where(group_manager_id: @user.id)
    end
  
    render json: @group_manager_teams
  end
  
  # GET /group_manager_teams/1
  def show
    render json: @group_manager_team
  end
  
  # PATCH/PUT /group_manager_teams/1
  def update
    has_updated = @group_manager_team.update(group_manager_team_params.except(:permission))

    if has_updated
      @permission = Permission.where(group_manager_team_id: @group_manager_team.id).first
      if params[:group_manager_team].has_key?(:permission)
        if @permission.update({ models_manage: group_manager_team_params.fetch(:permission) })
          render json: @group_manager_team, status: :ok
        else
          render json: @permission.errors, status: :unprocessable_entity
        end
      else
        render json: @group_manager_team, status: :ok
      end
    else
      render json: @group_manager_team.errors, status: :unprocessable_entity
    end
  end

  # DELETE /group_manager_teams/1
  def destroy
    @group_manager_team.destroy!
  end

  def email_reset_password
    @group_manager_team = GroupManagerTeam.find_by_email(params[:email])

    if @group_manager_team.present?
      aux_code = rand(36**4).to_s(36)
      reset_password_token = rand(36**10).to_s(36)

      @group_manager_team.update_attribute(:aux_code, aux_code)
      @group_manager_team.update_attribute(:reset_password_token, reset_password_token)
      GroupManagerTeamMailer.reset_password_email(@group_manager_team).deliver
      render json: {message: "Email enviado com sucesso"}, status: :ok
    else
      render json: {error: true, message: "Email não encontrado"}, status: :bad_request
    end
  end

  def show_reset_token
    group_manager_team = GroupManagerTeam.where(aux_code: params[:code]).first
    if group_manager_team.present?
      render json: {reset_password_token: group_manager_team.reset_password_token}, status: :ok
    else
      render json: {error: true, message: "Codigo invalido"}, status: :bad_request
    end
  end

  def reset_password
    @group_manager_team = GroupManagerTeam.where(reset_password_token: params[:reset_password_token]).first
    if @group_manager_team.present?
      if @group_manager_team.reset_password(params[:password], params[:password_confirmation])
        render json: {error: false, message: "Senha redefinida com sucesso"}, status: :ok
      else
        render json: {error: true, data: @group_manager_team.errors}, status: :bad_request
      end
    else
      render json: {error: true, message: "Token invalido"}, status: :bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_manager_team
      @group_manager_team = GroupManagerTeam.find(params[:id])
    end
  
    def set_app
      @app = App.find current_admin.app_id
    end
  
    # Only allow a trusted parameter "white list" through.
    def group_manager_team_params
      params.require(:group_manager_team).permit(
        :name,
        :email,
        :password,
        :group_manager_id,
        :app_id,
        :first_access,
        :permission => []
      )
    end
end
  