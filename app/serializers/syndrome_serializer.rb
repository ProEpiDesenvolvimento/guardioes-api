class SyndromeSerializer < ActiveModel::Serializer
  attributes :id, :description, :details

  has_one :message
  has_many :symptoms
end
