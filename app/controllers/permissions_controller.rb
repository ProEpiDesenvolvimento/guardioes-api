class PermissionsController < ApplicationController
  before_action :set_user_permission, only: [:show]
  load_and_authorize_resource

  # GET /permissions/1
  def show
    render json: @permissions
  end

  # POST /permissions
  def create
    @permissions = Permission.new(permission_params)

    if @permissions.save
      render json: @permissions, status: :created, location: @permissions
    else
      render json: @permissions.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /permissions/1
  def update
    if @permissions.update(permission_params)
      render json: @permissions
    else
      render json: @permissions.errors, status: :unprocessable_entity
    end
  end

  def destroy

  end
    
  private
  def set_user_permission
    @permissions = Permission.find(params[:id])
  end

  def permission_params
    params.require(:permission).permit(
      :admin_id,
      :manager_id,
      :city_manager_id,
      :group_manager_id,
      :group_manager_team_id,
      models_create: [],
      models_read: [],
      models_update: [],
      models_destroy: [],
      models_manage: [],
    )
  end 
end