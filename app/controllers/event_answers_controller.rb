class EventAnswersController < ApplicationController
  before_action :set_event_answer, only: [:show, :update, :destroy]

  # GET /event_answers
  def index
    @event_answers = EventAnswer.all

    render json: @event_answers
  end

  # GET /event_answers/1
  def show
    render json: @event_answer
  end

  # POST /event_answers
  def create
    @event_answer = EventAnswer.new(event_answer_params)

    if @event_answer.save
      render json: @event_answer, status: :created, location: @event_answer
    else
      render json: @event_answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_answers/1
  def update
    if @event_answer.update(event_answer_params)
      render json: @event_answer
    else
      render json: @event_answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_answers/1
  def destroy
    @event_answer.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_answer
      @event_answer = EventAnswer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_answer_params
      params.require(:event_answer).permit(:data, :user_id)
    end
end
