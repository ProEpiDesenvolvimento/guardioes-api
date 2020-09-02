class GroupSerializer < ActiveModel::Serializer
  attributes :id, :description, :kind, :details
  has_one :manager
end
