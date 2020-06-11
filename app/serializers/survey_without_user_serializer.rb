class SurveyWithoutUserSerializer < ActiveModel::Serializer
    attributes :id, :latitude, :longitude, :bad_since, :traveled_to, :symptom, :created_at, :street, :city, :state, :country, :went_to_hospital, :contact_with_symptom
    has_one :user, :serializer => UserWithoutNameSerializer
  end
  