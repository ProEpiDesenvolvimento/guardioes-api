class FlexibleAnswerSerializer < ActiveModel::Serializer
  attributes :id, :data, :created_at, :updated_at
  belongs_to :flexible_form_version
  has_one :flexible_form, through: :flexible_form_version
  belongs_to :user
end
