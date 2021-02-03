class ContentsController < ApplicationController
  # before_action :authenticate_admin!, only: [:create, :destroy, :update]
  before_action :set_content, only: [:show, :update, :destroy]
  load_and_authorize_resource

  # GET /contents
  def index
    if current_user.nil? && current_manager.nil?
      @user = current_admin
    elsif current_admin.nil? && current_user.nil?
      @user = current_manager
    else
      @user = current_user
    end

    @contents = Content.user_country(@user.app_id)

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
      render json: @content, status: :created, location: @content
    else
      render json: @content.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contents/1
  def update
    if @content.update(content_params)
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
      params.require(:content).permit(:title, :body, :icon, :content_type, :app_id, :source_link)
    end

    
end
