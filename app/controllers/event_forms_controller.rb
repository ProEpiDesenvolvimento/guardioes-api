class EventFormsController < ApplicationController
  before_action :set_event_form, only: [:show, :update, :destroy]

  # GET /event_forms
  def index
    @event_forms = EventForm.all

    render json: @event_forms
  end

  # GET /event_forms/1
  def show
    render json: @event_form
  end

  # POST /event_forms
  def create
    @event_form = EventForm.new(event_form_params)

    if @event_form.save
      render json: @event_form, status: :created, location: @event_form
    else
      render json: @event_form.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_forms/1
  def update
    if @event_form.update(event_form_params)
      render json: @event_form
    else
      render json: @event_form.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_forms/1
  def destroy
    @event_form.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_form
      @event_form = EventForm.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_form_params
      params.require(:event_form).permit(:title, :description, :data, :group_manager)
    end
end
