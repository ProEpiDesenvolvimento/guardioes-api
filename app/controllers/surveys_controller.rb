# frozen_string_literal: true

class SurveysController < ApplicationController
  before_action :authenticate_user!, except: %i[render_without_user all_surveys limited_surveys surveys_to_csv]
  before_action :authenticate_group_manager!, only: [:group_data]
  before_action :set_survey, only: %i[show update destroy]
  before_action :set_user, only: %i[index create]
  before_action :set_group, only: [:group_data]

  @WEEK_SURVEY_CACHE_EXPIRATION = 15.minute
  @LIMITED_SURVEY_CACHE_EXPIRATION = 15.minute

  # GET /surveys
  # GET user related surveys
  def index
    @surveys = Survey.filter_by_user(current_user.id)

    render json: @surveys, each_serializer: SurveyDailyReportsSerializer
  end

  # GET /surveys/group/1 id of group
  def group_data
    @surveys = []
    User.where('group_id = ?', params[:id]).find_each do |user|
      @surveys.concat(Survey.filter_by_user(user.id).to_a)
    end
    respond_to do |format|
      format.all { render json: @surveys }
      format.csv { send_data to_csv_search_data, filename: "surveys-#{Date.today}.csv" }
    end
  end

  def surveys_to_csv
    # This returns a file or json containing all surveys data
    # if you go to API/surveys/to_csv/:begin/:end/:password you get the json
    # if you go to API/surveys/to_csv/:begin/:end/:password.csv you get the csv
    # :begin and :end can be an iso datetime OR the string "now" (in which case, datetime is now)
    # :password is set as enviroment variable in docker-compose
    return render json: { message: 'You must provide the right key' } if params[:key] != ENV['CSV_DATA_KEY']

    filters = [
      :id, :created_at, 'user_id', 'user_name', :user_created_at, :identification_code, 'household_id', 'household_created_at', 'household_identification_code'
    ]
    begin_datetime = params[:begin]
    end_datetime = params[:end]
    begin_datetime = DateTime.now.strftime('%Y-%m-%d %H:%M:%S %z') if begin_datetime == 'now'
    end_datetime = DateTime.now.strftime('%Y-%m-%d %H:%M:%S %z') if end_datetime == 'now'
    begin_datetime = DateTime.parse(begin_datetime)
    end_datetime = DateTime.parse(end_datetime)
    @surveys = Survey.where('created_at >= ? AND created_at <= ?', begin_datetime, end_datetime).all
    if @surveys.empty?
      return render json: { message: "No data was found in given period:   #{begin_datetime} -> #{end_datetime}" }
    end

    respond_to do |format|
      format.all { render json: { message: 'You must append \'.csv\' to the end of the url' } }
      format.csv { send_data to_csv_csv_data, filename: "surveys-#{begin_datetime}-#{end_datetime}.csv" }
    end
  end

  def all_surveys
    @surveys = Survey.all

    render json: @surveys
  end

  # GET /surveys/1
  def show
    render json: @survey
  end

  # POST /surveys
  def create
    @survey = Survey.new(survey_params)
    @survey.user_id = @user.id

    date = DateTime.now.in_time_zone(Time.zone).beginning_of_day
    past_surveys = Survey.filter_by_user(current_user.id).where('created_at >= ?', date).where(household: @survey.household)

    if past_surveys.length == 2
      render json: { errors: 'The user already contributed two times today' }, status: :unprocessable_entity
    elsif past_surveys[0] && past_surveys[0].symptom[0] && @survey.symptom[0]
      render json: { errors: 'The user already contributed with this survey today' }, status: :unprocessable_entity
    elsif past_surveys[0] && !past_surveys[0].symptom[0] && !@survey.symptom[0]
      render json: { errors: 'The user already contributed with this survey today' }, status: :unprocessable_entity
    elsif @survey.save
      @user.update_streak(@survey)
      if @survey.symptom.length.positive?
        render json: { survey: @survey, feedback_message: @user.get_feedback_message(@survey), messages: @survey.get_message(@user) }, status: :created, location: user_survey_path(id: @user)
      else
        render json: { survey: @survey, feedback_message: @user.get_feedback_message(@survey) }, status: :created, location: user_survey_path(id: @user)
      end
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  # DELETE /surveys/1
  def destroy
    @survey.destroy
  end

  def weekly_surveys
    # Rails.cache.fetch tries to get that key 'week_surveys', if it fails,
    # it runs the block and sets the cache as the return of the block
    json = Rails.cache.fetch('week_surveys', expires_in: @WEEK_SURVEY_CACHE_EXPIRATION) do
      render_to_string json: @surveys = Survey.where('created_at >= ?', 1.week.ago.utc), each_serializer: SurveyForMapSerializer
    end
    render json: json, each_serializer: SurveyForMapSerializer
  end

  def render_without_user
    @surveys = Survey.all

    render json: @surveys, each_serializer: SurveyWithoutUserSerializer
  end

  def limited_surveys
    # Rails.cache.fetch tries to get that key 'limited_surveys', if it fails,
    # it runs the block and sets the cache as the return of the block
    json = Rails.cache.fetch('limited_surveys', expires_in: @LIMITED_SURVEY_CACHE_EXPIRATION) do
      render_to_string json: @surveys = Survey.where('created_at >= ?', 12.hour.ago.utc), each_serializer: SurveyForMapSerializer
    end

    render json: json, root: 'surveys', each_serializer: SurveyForMapSerializer
  end

  private

  def to_csv_search_data
    attributes = []
    @surveys.first.search_data.each do |key, _value|
      attributes.append(key)
    end

    CSV.generate(headers: true) do |csv|
      csv << attributes
      @surveys.each do |survey|
        csv << survey.search_data.map { |_key, value| value.to_s }
      end
    end
  end

  def to_csv_csv_data
    attributes = []
    @surveys.first.csv_data.each do |key, _value|
      attributes.append(key)
    end

    CSV.generate(headers: true) do |csv|
      csv << attributes
      @surveys.each do |survey|
        csv << survey.csv_data.map { |_key, value| value.to_s }
      end
    end
  end

  def set_group
    @group = Group.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_survey
    @survey = Survey.find(params[:id])
  end

  def set_user
    @user = User.find(current_user.id)
  end

  # Only allow a trusted parameter "white list" through.
  def survey_params
    params.require(:survey).permit(
      :user_id,
      :household_id,
      :latitude,
      :longitude,
      :bad_since,
      :traveled_to,
      :street,
      :city,
      :state,
      :country,
      :went_to_hospital,
      :contact_with_symptom,
      symptom: []
    )
  end
end
