class FlexibleFormsController < ApplicationController
  before_action :set_flexible_form, only: [:show, :update, :destroy]
  authorize_resource :except => [:registration, :signal, :quizzes]

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

  # GET /flexible_forms/registration/:app_id
  def registration
    @app = App.find(params[:app_id])
    
    @flexible_form = FlexibleForm.find_by(form_type: "registration", app_id: @app.id)

    render json: @flexible_form
  end

  # GET /flexible_forms/signal
  def signal
    if current_group_manager
      group_manager_id = current_group_manager.id
    elsif current_group_manager_team
      group_manager_id = current_group_manager_team.group_manager.id
    elsif current_user
      group_manager_id = current_user.group.group_manager.id
    end

    @flexible_form = FlexibleForm.find_by(form_type: "signal", group_manager_id: group_manager_id)
    
    render json: @flexible_form
  end

  # GET /flexible_forms/quizzes
  def quizzes
    if current_group_manager
      group_manager_id = current_group_manager.id
    elsif current_group_manager_team
      group_manager_id = current_group_manager_team.group_manager.id
    elsif current_user
      group_manager_id = current_user.group.group_manager.id
    end

    @flexible_forms = FlexibleForm.where(form_type: "quiz", group_manager_id: group_manager_id).order(created_at: :desc)

    render json: @flexible_forms
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flexible_form
      @flexible_form = FlexibleForm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def flexible_form_params
      params.require(:flexible_form).permit(:title, :description, :form_type, :data, :group_manager_id, :app_id)
    end
end
