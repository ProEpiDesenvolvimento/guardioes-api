class HouseholdSerializer < ActiveModel::Serializer
  attributes :id, :description, :birthdate, :country, :gender, :race, :kinship
  has_one :user
end
