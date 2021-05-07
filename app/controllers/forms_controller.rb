class FormsController < ApplicationController
  before_action :set_form, only: [:show, :update, :destroy]
  before_action :set_questions, only: [ :create ]

  load_and_authorize_resource :except => [:create] 

  # GET /forms
  def index
    @forms = Form.all

    render json: @forms
  end

  # GET /forms/1
  def show
    render json: @form
  end

  # GET forms/1/answers
  def form_answers
  end

  # POST /forms
  def create
    @questions = form_params[:questions]
    @form = Form.new(form_params.except(:questions))

    if @form.save
      @group_manager = GroupManager.find_by(id: form_params[:group_manager_id])
      if @group_manager
        @group_manager.update(:form => @form)
      end
      if !form_params[:questions].nil?
        create_questions_and_options_for_form
      end
      render json: @form, status: :created, location: @form
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /forms/1
  def update
    @questions = form_params[:questions]
    if @form.update(form_params.except(:questions))
      if !form_params.except(:questions).nil?
        update_questions_for_form
      end
      render json: @form
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  # DELETE /forms/1
  def destroy
    @form.destroy
  end

  private
    def create_questions_and_options_for_form
      @questions.each do |question|
        created_question = FormQuestion.create(
          kind: question[:kind],
          text: question[:text],
          order: question[:order],
          form: @form,
        )

        question[:options].each do |option|
          created_option = FormOption.create(
            value: option[:value],
            text: option[:text],
            order: option[:order],
            form_question: created_question,
          )
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    def set_questions
      @questions = params[:questions]
    end

    # Only allow a trusted parameter "white list" through.
    def form_params
      params.require(:form).permit(
        :group_manager_id,
        :questions => [[
          :kind,
          :text,
          :order,
          :options => [[ :value, :text, :order ]]
        ]],
      )
    end
end
