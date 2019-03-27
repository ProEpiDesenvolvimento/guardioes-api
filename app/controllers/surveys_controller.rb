class SurveysController < ApplicationController
  before_action :authenticate_user!
  # before_action :user_eq_token_id
  before_action :set_survey, only: [:show, :update, :destroy]
  before_action :set_user, only: [:index, :create]

  # GET /surveys  
  def index
    @surveys = Survey.filter_by_user(current_user.id)

    render json: @surveys
  end

  # GET /surveys/1
  def show
    render json: @survey
  end

  # POST /surveys
  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      render json: @survey, status: :created, location: user_survey_path(:id => @user)
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /surveys/1
  # def update
  #   if @survey.update(survey_params)
  #     render json: @survey
  #   else
  #     render json: @survey.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /surveys/1
  def destroy
    @survey.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    def set_user
      @user = User.find(current_user.id)
    end

    # def user_eq_token_id
    #   unless current_user.id == params[:user_id]
    #     render json: { message: "Você não tem acesso à esses dados"}
    #   end
    # end

    # Only allow a trusted parameter "white list" through.
    def survey_params
      params.require(:survey).permit(
        :user_id, 
        :household_id, 
        :latitude, 
        :longitude, 
        :bad_since, 
        :had_traveled, 
        :where_had_traveled, 
        :event_title, 
        :event_description, 
        :event_confirmed_cases, 
        :event_confirmed_cases_number, 
        :event_confirmed_deaths, 
        :event_confirmed_deaths_number, 
        :street, 
        :city, 
        :state, 
        :country,
        symptom: []
      ) 
    end
end
