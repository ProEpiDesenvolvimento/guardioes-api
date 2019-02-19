require 'test_helper'

class PublicHospitalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @public_hospital = public_hospitals(:one)
  end

  test "should get index" do
    get public_hospitals_url, as: :json
    assert_response :success
  end

  test "should create public_hospital" do
    assert_difference('PublicHospital.count') do
      post public_hospitals_url, params: { public_hospital: { app_id: @public_hospital.app_id, description: @public_hospital.description, details: @public_hospital.details, latitude: @public_hospital.latitude, longitude: @public_hospital.longitude, phone: @public_hospital.phone, type: @public_hospital.type } }, as: :json
    end

    assert_response 201
  end

  test "should show public_hospital" do
    get public_hospital_url(@public_hospital), as: :json
    assert_response :success
  end

  test "should update public_hospital" do
    patch public_hospital_url(@public_hospital), params: { public_hospital: { app_id: @public_hospital.app_id, description: @public_hospital.description, details: @public_hospital.details, latitude: @public_hospital.latitude, longitude: @public_hospital.longitude, phone: @public_hospital.phone, type: @public_hospital.type } }, as: :json
    assert_response 200
  end

  test "should destroy public_hospital" do
    assert_difference('PublicHospital.count', -1) do
      delete public_hospital_url(@public_hospital), as: :json
    end

    assert_response 204
  end
end
