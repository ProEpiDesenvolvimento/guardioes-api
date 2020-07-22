class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy, :get_path, :get_children]

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
    if @group.save
      render json: @group, status: :created, location: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # GET /groups/1/get_path
  def get_path
    path = []
    begin
      path = @group.get_path(false)
    rescue
      return render json: "Could not find path", status: :unprocessable_entity
    end
    render json: path, status: :ok
  end

  # GET /groups/1/get_children
  def get_children
    is_child = @group.children_label == nil
    children = ActiveModel::SerializableResource.new(@group.children).as_json()
    render json: { is_child: is_child, children: children[:groups] }, status: :ok
  end

  # DELETE /groups/1
  def destroy
    @group.delete_subtree
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
        :parent_id
      )
    end
end
