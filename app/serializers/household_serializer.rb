class HouseholdSerializer < ActiveModel::Serializer
  attributes :id, :description, :birthdate, :country, :gender, :race, :kinship, :picture
  has_one :user
end
