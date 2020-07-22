class GroupSerializer < ActiveModel::Serializer
  attributes :id, :description, :children_label, :parent_id
end
