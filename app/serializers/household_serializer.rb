class HouseholdSerializer < ActiveModel::Serializer
  attributes :id, :description, :birthdate, :country, :gender, :race, :kinship, :picture, :school_unit_id, :identification_code, :risk_group
  has_one :user
end
