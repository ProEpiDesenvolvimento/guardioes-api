class SurveySerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :bad_since, :traveled_to, :symptom, :created_at, :street, :city, :state, :country, :went_to_hospital, :contact_with_symptom, :syndrome_id

  has_one :user
  has_one :household
end
