class SurveySerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :symptom, :bad_since, :created_at,
             :postal_code, :street, :city, :state, :country, :traveled_to,
             :went_to_hospital, :contact_with_symptom, :syndrome_id, :reviewed

end
