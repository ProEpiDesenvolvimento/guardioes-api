class SurveySerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :bad_since, :traveled_to, :symptom, :created_at, :event_title, :event_description, :event_confirmed_cases_number, :event_confirmed_deaths_number, :street, :city, :state, :country, :went_to_hospital, :contact_with_symptom

  has_one :user
  has_one :household
end
