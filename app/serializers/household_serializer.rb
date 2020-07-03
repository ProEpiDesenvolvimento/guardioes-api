class HouseholdSerializer < ActiveModel::Serializer
  attributes :id, :description, :birthdate, :country, :gender, :race, :kinship, :picture, :school_unit_id, :identification_code
  has_one :user
end
