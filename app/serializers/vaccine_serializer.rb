class VaccineSerializer < ActiveModel::Serializer
  attributes :id, :name, :country_origin, :laboratory, :doses, :disease, :min_dose_interval, :max_dose_interval, :app_id
end
  