class FormSerializer < ActiveModel::Serializer
  attributes :id

  has_many :form_questions
  has_one :group_manager
end
