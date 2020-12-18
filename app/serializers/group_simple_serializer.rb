class GroupSimpleSerializer < ActiveModel::Serializer
    attributes :id, :description, :label, :children_label
end
  