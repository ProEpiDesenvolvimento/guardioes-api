class VbeAnswersController < ApplicationController
  before_action :set_vbe_answer, only: [:show, :update, :destroy]

  # GET /vbe_answers
  def index
    @vbe_answers = VbeAnswer.all

    render json: @vbe_answers
  end

  # GET /vbe_answers/1
  def show
    render json: @vbe_answer
  end

  # POST /vbe_answers
  def create
    @vbe_answer = VbeAnswer.new(vbe_answer_params)

    if @vbe_answer.save
      render json: @vbe_answer, status: :created, location: @vbe_answer
    else
      render json: @vbe_answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vbe_answers/1
  def update
    if @vbe_answer.update(vbe_answer_params)
      render json: @vbe_answer
    else
      render json: @vbe_answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vbe_answers/1
  def destroy
    @vbe_answer.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vbe_answer
      @vbe_answer = VbeAnswer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def vbe_answer_params
      params.require(:vbe_answer).permit(:data, :vbe_form_id)
    end
end
