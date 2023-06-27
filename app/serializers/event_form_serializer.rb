class EventFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :data
  has_one :group_manager
end
