class FormSerializer < ActiveModel::Serializer
  attributes :id
  has_one :group_manager
  has_one :group
end
