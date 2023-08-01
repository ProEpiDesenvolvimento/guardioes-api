class FlexibleFormsController < ApplicationController
  before_action :set_flexible_form, only: [:show, :update, :destroy]

  # GET /flexible_forms
  def index
    @flexible_forms = FlexibleForm.all

    render json: @flexible_forms
  end

  # GET /flexible_forms/1
  def show
    render json: @flexible_form
  end

  # POST /flexible_forms
  def create
    @flexible_form = FlexibleForm.new(flexible_form_params.except(:data))

    @flexible_form_version = FlexibleFormVersion.new(
      version: 1,
      notes: "Initial version",
      flexible_form: @flexible_form,
      data: flexible_form_params[:data],
      version_date: DateTime.now
    )

    if @flexible_form.save && @flexible_form_version.save
      render json: @flexible_form, status: :created, location: @flexible_form
    else
      render json: @flexible_form.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /flexible_forms/1
  def update
    if @flexible_form.update(flexible_form_params)
      render json: @flexible_form
    else
      render json: @flexible_form.errors, status: :unprocessable_entity
    end
  end

  # DELETE /flexible_forms/1
  def destroy
    @flexible_form.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flexible_form
      @flexible_form = FlexibleForm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def flexible_form_params
      params.require(:flexible_form).permit(:title, :description, :form_type, :data, :group_manager_id)
    end
end
