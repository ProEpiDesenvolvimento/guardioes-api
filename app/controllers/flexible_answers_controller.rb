class FlexibleAnswersController < ApplicationController
  before_action :set_flexible_answer, only: [:show, :update, :destroy]
  authorize_resource
  # GET /flexible_answers
  NUMERO_SINAIS_RETORNADOS = 999
  NUMERO_PAGIN = 0

  def index
    @flexible_answers = FlexibleAnswer.where(user_id: current_user.id)
    @signals_list = ExternalIntegrationService.list_signals_by_user_id(NUMERO_PAGIN,
                                                                       NUMERO_SINAIS_RETORNADOS,
                                                                       current_user.id)
    @signals_dict = ExternalIntegrationService.convert_to_dict(@signals_list)

    render json: @flexible_answers, each_serializer: FlexibleAnswerSerializer, scope: @signals_dict
  end

  # GET /flexible_answers/1
  def show
    render json: @flexible_answer
  end

  # POST /flexible_answers
  def create
    @flexible_answer = FlexibleAnswer.new(flexible_answer_params)
    @flexible_answer.user_id = current_user.id

    if @flexible_answer.save
      if @flexible_answer.flexible_form.form_type == 'signal'
        external_system_integration_id = ExternalIntegrationService.create_event(@flexible_answer)
        @flexible_answer.update_attribute(:external_system_integration_id, external_system_integration_id)
      end
      render json: @flexible_answer, status: :created, location: @flexible_answer
    else
      render json: @flexible_answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /flexible_answers/1
  def update
    if @flexible_answer.update(flexible_answer_params)
      render json: @flexible_answer
    else
      render json: @flexible_answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /flexible_answers/1
  def destroy
    @flexible_answer.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_flexible_answer
    @flexible_answer = FlexibleAnswer.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def flexible_answer_params
    params.require(:flexible_answer).permit(:flexible_form_version_id, :data, :user_id, :external_system_integration_id)
  end
end
