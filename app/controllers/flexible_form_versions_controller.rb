class FlexibleFormVersionsController < ApplicationController
  before_action :set_flexible_form_version, only: [:show, :update, :destroy]

  # GET /flexible_form_versions
  def index
    @flexible_form_versions = FlexibleFormVersion.all

    render json: @flexible_form_versions
  end

  # GET /flexible_form_versions/1
  def show
    render json: @flexible_form_version
  end

  # POST /flexible_form_versions
  def create
    @flexible_form_version = FlexibleFormVersion.new(flexible_form_version_params)

    if @flexible_form_version.save
      render json: @flexible_form_version, status: :created, location: @flexible_form_version
    else
      render json: @flexible_form_version.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /flexible_form_versions/1
  def update
    if @flexible_form_version.update(flexible_form_version_params)
      render json: @flexible_form_version
    else
      render json: @flexible_form_version.errors, status: :unprocessable_entity
    end
  end

  # DELETE /flexible_form_versions/1
  def destroy
    @flexible_form_version.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flexible_form_version
      @flexible_form_version = FlexibleFormVersion.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def flexible_form_version_params
      params.require(:flexible_form_version).permit(:version, :notes, :flexible_form_id, :data, :version_date)
    end
end
