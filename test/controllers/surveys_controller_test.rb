require 'test_helper'

class SurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:one)
  end

  test "should get index" do
    get surveys_url, as: :json
    assert_response :success
  end

  test "should create survey" do
    assert_difference('Survey.count') do
      post surveys_url, params: { survey: { bad_since: @survey.bad_since, city: @survey.city, country: @survey.country, event: @survey.event, event_confirmed_cases: @survey.event_confirmed_cases, event_confirmed_cases_number: @survey.event_confirmed_cases_number, event_confirmed_deaths: @survey.event_confirmed_deaths, event_confirmed_deaths_number: @survey.event_confirmed_deaths_number, event_description: @survey.event_description, had_traveled: @survey.had_traveled, household_id: @survey.household_id, latitude: @survey.latitude, longitude: @survey.longitude, state: @survey.state, street: @survey.street, symptom: @survey.symptom, user_id: @survey.user_id, where_had_traveled: @survey.where_had_traveled } }, as: :json
    end

    assert_response 201
  end

  test "should show survey" do
    get survey_url(@survey), as: :json
    assert_response :success
  end

  test "should update survey" do
    patch survey_url(@survey), params: { survey: { bad_since: @survey.bad_since, city: @survey.city, country: @survey.country, event: @survey.event, event_confirmed_cases: @survey.event_confirmed_cases, event_confirmed_cases_number: @survey.event_confirmed_cases_number, event_confirmed_deaths: @survey.event_confirmed_deaths, event_confirmed_deaths_number: @survey.event_confirmed_deaths_number, event_description: @survey.event_description, had_traveled: @survey.had_traveled, household_id: @survey.household_id, latitude: @survey.latitude, longitude: @survey.longitude, state: @survey.state, street: @survey.street, symptom: @survey.symptom, user_id: @survey.user_id, where_had_traveled: @survey.where_had_traveled } }, as: :json
    assert_response 200
  end

  test "should destroy survey" do
    assert_difference('Survey.count', -1) do
      delete survey_url(@survey), as: :json
    end

    assert_response 204
  end
end
