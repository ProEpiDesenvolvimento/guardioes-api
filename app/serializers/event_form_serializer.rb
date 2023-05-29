class EventFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :data, :group_manager
end
