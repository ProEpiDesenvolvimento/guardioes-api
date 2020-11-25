class GroupsController < ApplicationController
  before_action :set_group, except: [:index,:upload_group_file,:create,:root,:build_country_city_state_groups]
  before_action :check_authenticated_admin_or_manager, except: [:get_path,:get_children,:show,:root,:get_twitter]
  before_action :validate_invalid_group_name, only: [:create,:update]
  before_action :authenticate_admin!, only: [:build_country_city_state_groups]

  include GroupsHelper

  # GET /groups
  def index
    @groups = Group.all
    
    render json: @groups
  end

  # GET /groups/1
  def show
    render json: @group
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    if (current_group_manager)
      ManagerGroupPermission::permit(current_group_manager, @group)
      @group.group_manager_id = current_group_manager.id
    end
    return render json: 'Not enough permissions' if !validate_manager_group_permissions
    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    return render json: 'Not enough permissions' if !validate_manager_group_permissions
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.delete_subtree
  end

  # GET /groups/root
  def root
    return render json: Group::get_root
  end

  # GET /groups/1/get_path
  def get_path
    path = []
    path = @group.get_path(false)
    path = { "groups": [] } if path.empty?
    render json: path, status: :ok, each_serializer: GroupSimpleSerializer
  end

  # GET /groups/1/get_children
  def get_children
    is_child = @group.children_label == nil
    children = @group.children.each.map {|x| GroupSimpleSerializer.new(x) }
    render json: { label: @group.children_label, is_child: is_child, require_id: @group.require_id || false, children: children }, status: :ok
  end

  # POST /groups/upload_group_file/
  def upload_group_file(build_country_city_state_model = false)
    handle_errors do
      validate_group_manager(build_country_city_state_model)
      data = Roo::Spreadsheet.open(params[:file], extension: :xls) # Open spreadsheet data

      headers = data.row(1) # First row containing headers for table
      
      validate_mandatory_columns headers

      rows_to_create = get_rows(build_country_city_state_model, headers, data)
      create_groups(rows_to_create, build_country_city_state_model)

      render json: {message: 'All groups created', error: false}, status: :created
    end
  end

  # POST /groups/build_country_city_state_groups/
  # This is used only by admins to build countries, states and municipalities
  # into database with an .xls file
  def build_country_city_state_groups
    self.upload_group_file(true)
  end

  # GET /groups/:id/get_twitter
  def get_twitter
    render json: { twitter: @group.get_twitter }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(
        :description, 
        :children_label,
        :parent_id,
        :code,
        :address,
        :cep,
        :phone,
        :email
      )
    end

    def check_authenticated_admin_or_manager
      if current_admin.nil? && current_group_manager.nil?
        return render json: {}, status: :ok
      end
    end
  
    def validate_manager_group_permissions(group = @group)
      if current_group_manager != nil && !current_group_manager.is_permitted?(group)
        return false
      end
      return true
    end

  def handle_errors
    yield
  rescue CustomException => e
    render json: e.data, status: e.status
    return
  end
end