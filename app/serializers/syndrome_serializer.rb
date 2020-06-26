class SyndromeSerializer < ActiveModel::Serializer
  attributes :id, :description, :details

  has_one :message
end
