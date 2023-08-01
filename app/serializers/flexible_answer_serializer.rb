class FlexibleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :data, :created_at, :updated_at
  has_one :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  has_one :user
end
