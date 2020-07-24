class ManagersController < ApplicationController
  before_action :authenticate_admin!, only: [:index]
  before_action :set_app, only: [:index]
  before_action :check_authenticated_admin_or_manager, only: [:show, :add_manager_permission,:is_manager_permitted, :remove_manager_permission]
  before_action :set_manager_and_group, only: [:is_manager_permitted, :add_manager_permission, :remove_manager_permission]

  # GET /managers/
  def index
    render json: @app.managers
  end

  def show 
    render json: Manager.find(params[:id])
  end

  # GET /managers/:manager_id/:group_id/permit
  def add_manager_permission
    # Validate either admin or manager with sufficient permissions
    if current_admin != nil || (current_manager != nil  && current_manager.is_permitted?(@group))
      ManagerGroupPermission::permit(@manager, @group)
      return render json: { error: false }, status: :ok
    end
    return render json: { error: true, message: 'Not enough permitions' }, status: :ok
  end

  # GET /managers/:manager_id/:group_id/unpermit
  def remove_manager_permission
    # Validate either admin or manager with sufficient permissions
    if @manager == current_manager
      return render json: { error: true, message: 'Cannot unpermit yourself' }, status: :ok
    end
    if current_admin != nil || (current_manager != nil  && current_manager.is_permitted?(@group))
      ManagerGroupPermission.where(group_id: @group.id, manager_id: @manager.id).all.each do |p|
        p.destroy
      end
      return render json: { error: false }, status: :ok
    end
    return render json: { error: true, message: 'Not enough permitions' }, status: :ok
  end

  # GET /managers/:manager_id/:group_id
  def is_manager_permitted
    is_permitted = @manager.is_permitted?(@group)
    if is_permitted
      return render json: { is_permitted: true, group: @group.get_path(true).join('/') }, status: :ok
    else
      return render json: { is_permitted: false, group: @group.get_path(true).join('/') }, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find current_admin.app_id
    end

    def set_manager_and_group
      @manager = Manager.find(params[:manager_id])
      @group = Group.find(params[:group_id])
    end

    def check_authenticated_admin_or_manager
      if current_admin.nil? && current_manager.nil?
        return render json: {}, status: :ok
      end
    end
end