class GroupManagersController < ApplicationController
  before_action :authenticate_admin!, only: [:index]
  before_action :set_app, only: [:index]
  before_action :check_authenticated_admin_or_manager, only: [:show, :add_manager_permission,:is_manager_permitted, :remove_manager_permission]
  before_action :set_manager_and_group, only: [:is_manager_permitted, :add_manager_permission, :remove_manager_permission]

  # GET /group_managers/
  def index
    render json: @app.group_managers
  end

  def show
    # Validates only admins or the manager can see a certain manager
    if current_admin.nil? && current_group_manager != GroupManager.find(params[:id])
      return render json: GroupManager.new()
    end
    render json: GroupManager.find(params[:id])
  end

  # THIS IS A GROUP MANAGER PERMISSION GIVING SYSTEM
  # For now, as this feature is complex, this is comented. In the future, this will be patched to
  # be safe.

  # # GET /group_managers/:manager_id/:group_id/permit
  # def add_manager_permission
  #   # Validate either admin or manager with sufficient permissions
  #   if current_admin != nil || (current_manager != nil  && current_manager.is_permitted?(@group))
  #     ManagerGroupPermission::permit(@manager, @group)
  #     return render json: { error: false }, status: :ok
  #   end
  #   return render json: { error: true, message: 'Not enough permitions' }, status: :ok
  # end

  # # GET /group_managers/:manager_id/:group_id/unpermit
  # def remove_manager_permission
  #   # Validate either admin or manager with sufficient permissions
  #   if @manager == current_manager
  #     return render json: { error: true, message: 'Cannot unpermit yourself' }, status: :ok
  #   end
  #   if current_admin != nil || (current_manager != nil  && current_manager.is_permitted?(@group))
  #     ManagerGroupPermission.where(group_id: @group.id, manager_id: @manager.id).all.each do |p|
  #       p.destroy
  #     end
  #     return render json: { error: false }, status: :ok
  #   end
  #   return render json: { error: true, message: 'Not enough permitions' }, status: :ok
  # end

  # GET /group_managers/:manager_id/:group_id
  def is_manager_permitted
    is_permitted = @manager.is_permitted?(@group)
    if is_permitted
      return render json: { is_permitted: true, group: @group.get_path(true).join('/') }, status: :ok
    else
      return render json: { is_permitted: false, group: @group.get_path(true).join('/') }, status: :ok
    end
  end

  # GET /group_managers/:group_id/get_users
  def get_users_in_manager_group

  end

  # DELETE /group_managers/:group_id/:user_id/remove_user_from_group
  def remove_user_in_manager_group

  end

  # DELETE /group_managers/:group_id/:user_id/add_user_to_group
  def add_users_in_manager_group

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find current_admin.app_id
    end

    def set_manager_and_group
      @manager = GroupManager.find(params[:group_manager_id])
      @group = Group.find(params[:group_id])
    end

    def check_authenticated_admin_or_manager
      if current_admin.nil? && current_group_manager.nil?
        return render json: {}, status: :ok
      end
    end
end