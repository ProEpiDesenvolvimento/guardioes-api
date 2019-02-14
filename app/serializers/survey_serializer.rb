class SurveySerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :bad_since, :had_traveled, :where_had_traveled, :symptom, :event_title, :event_description, :event_confirmed_cases, :event_confirmed_cases_number, :event_confirmed_deaths, :event_confirmed_deaths_number, :street, :city, :state, :country
  has_one :user
  has_one :household
end
