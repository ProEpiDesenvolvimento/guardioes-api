class CommunityGroupsController < ApplicationController
  before_action :set_community_group, only: [:show, :update, :destroy]

  # GET /community_groups
  def index
    @community_groups = CommunityGroup.all

    render json: @community_groups
  end

  # GET /community_groups/1
  def show
    render json: @community_group
  end

  # POST /community_groups
  def create
    @community_group = CommunityGroup.new(community_group_params)

    if @community_group.save
      render json: @community_group, status: :created, location: @community_group
    else
      render json: @community_group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /community_groups/1
  def update
    if @community_group.update(community_group_params)
      render json: @community_group
    else
      render json: @community_group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /community_groups/1
  def destroy
    @community_group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community_group
      @community_group = CommunityGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def community_group_params
      params.require(:community_group).permit(:name, :city, :email1, :email2, :email3)
    end
end
