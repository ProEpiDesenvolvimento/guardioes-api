class PublicHospitalSerializer < ActiveModel::Serializer
  attributes :id, :description, :latitude, :longitude, :type, :phone, :details
  has_one :app
end
