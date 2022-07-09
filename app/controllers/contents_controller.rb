class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :update, :destroy]
  load_and_authorize_resource

  # GET /contents
  def index
    @user = current_devise_user

    case @user
      when current_group_manager
        @contents = Content.where(group_manager_id: @user.id)
      when current_user
        if @user.group && @user.group.group_manager
          @contents = Content.where(group_manager_id: @user.group.group_manager.id)
        else
          @contents = Content.where(app_id: @user.app_id).where(group_manager_id: nil)
        end
      else
        @contents = Content.where(app_id: @user.app_id)
    end
  
    render json: @contents
  end

  # GET /contents/1
  def show
    render json: @content
  end

  # POST /contents
  def create
    @content = Content.new(content_params)

    if @content.save
      @content.update_attribute(:created_by, current_devise_user.email)
      render json: @content, status: :created, location: @content
    else
      render json: @content.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contents/1
  def update
    if @content.update(content_params)
      @content.update_attribute(:updated_by, current_devise_user.email)
      render json: @content
    else
      render json: @content.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contents/1
  def destroy
    @content.destroy

    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def content_params
      params.require(:content).permit(:title, :body, :icon, :content_type, :source_link, :group_manager_id, :app_id)
    end

    
end
