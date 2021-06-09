class GroupManagerTeamsController < ApplicationController
  # before_action :authenticate_admin!, only: [:index]
  # before_action :set_app, only: [:index]
  before_action :set_group_manager_team, only: [:show, :update, :destroy]
  
  # GET /group_manager_teams
  def index
    @group_manager_teams = GroupManagerTeam.all
  
    render json: @group_manager_teams
  end
  
  # GET /group_manager_teams/1
  def show
    render json: @group_manager_team
  end
  
  # PATCH/PUT /group_manager_teams/1
  def update
    if current_group_manager_team
      has_updated = @group_manager_team.update(group_manager_team_update_params)
    else
      has_updated = @group_manager_team.update(group_manager_team_params)
    end
  
    if has_updated
      render json: @group_manager_team
    else
      render json: @group_manager_team.errors, status: :unprocessable_entity
    end
  end
  
  # DELETE /group_manager_teams/1
  def destroy
    @group_manager_team.destroy!
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
        :app_id
      )
    end
    def group_manager_team_update_params
      params.require(:group_manager_team).permit(
        :name,
        :email,
        :password,
        :app_id
      )
    end
end
  