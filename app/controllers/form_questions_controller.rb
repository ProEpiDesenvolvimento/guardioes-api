class FormQuestionsController < ApplicationController
  before_action :set_form_question, only: [:show, :update, :destroy]

  load_and_authorize_resource :except => [:create] 

  # GET /form_questions
  def index
    @form_questions = FormQuestion.all

    render json: @form_questions
  end

  # GET /form_questions/1
  def show
    render json: @form_question
  end

  # POST /form_questions
  def create
    @form_question = FormQuestion.new(form_question_params)

    if @form_question.save
      render json: @form_question, status: :created, location: @form_question
    else
      render json: @form_question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /form_questions/1
  def update
    if @form_question.update(form_question_params)
      render json: @form_question
    else
      render json: @form_question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /form_questions/1
  def destroy
    @form_question.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_question
      @form_question = FormQuestion.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def form_question_params
      params.require(:form_question).permit(:kind, :text, :order, :form_id)
    end
end
