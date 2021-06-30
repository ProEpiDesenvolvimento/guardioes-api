class FormOptionsController < ApplicationController
  before_action :set_form_option, only: [:show, :update, :destroy]

  # GET /form_options
  def index
    @form_options = FormOption.all

    render json: @form_options
  end

  # GET /form_options/1
  def show
    render json: @form_option
  end

  # POST /form_options
  def create
    @form_option = FormOption.new(form_option_params)

    if @form_option.save
      render json: @form_option, status: :created, location: @form_option
    else
      render json: @form_option.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /form_options/1
  def update
    if @form_option.update(form_option_params)
      render json: @form_option
    else
      render json: @form_option.errors, status: :unprocessable_entity
    end
  end

  # DELETE /form_options/1
  def destroy
    @form_option.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_option
      @form_option = FormOption.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def form_option_params
      params.require(:form_option).permit(:value, :text, :order, :form_question_id)
    end
end
