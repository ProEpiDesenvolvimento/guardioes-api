class FormAnswersController < ApplicationController
  before_action :set_form_answer, only: [:show, :update, :destroy]

  load_and_authorize_resource :except => [:create]

  # GET /form_answers
  def index
    @form_answers = FormAnswer.all

    render json: @form_answers
  end

  # GET /form_answers/1
  def show
    render json: @form_answer
  end

  # POST /form_answers
  def create
    if params[:form_answers].nil?
      @form_answer = FormAnswer.new(form_answer_params)

      if @form_answer.save
        render json: @form_answer, status: :created, location: @form_answer
      else
        render json: @form_answer.errors, status: :unprocessable_entity
      end
    else
      @form_answers = []
      save = true

      params[:form_answers].each do |form_answer|
        fr = FormAnswer.new(form_answers_params(form_answer))
        save = fr.save
        @form_answers << fr
      end

      if save
        render json: { form_answers: @form_answers }, status: :created
      else
        render json: @form_answers.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /form_answers/1
  def update
    if @form_answer.update(form_answer_params)
      render json: @form_answer
    else
      render json: @form_answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /form_answers/1
  def destroy
    @form_answer.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_answer
      @form_answer = FormAnswer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def form_answer_params
      params.require(:form_answer).permit(:form_id, :form_question_id, :form_option_id, :user_id)
    end

    def form_answers_params(form_answer)
      form_answer.permit(:form_id, :form_question_id, :form_option_id, :user_id)
    end
end
