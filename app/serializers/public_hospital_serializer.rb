class PublicHospitalSerializer < ActiveModel::Serializer
  attributes :id, :description, :latitude, :longitude, :phone, :details
  has_one :app
end
