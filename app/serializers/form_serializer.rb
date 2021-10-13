class FormSerializer < ActiveModel::Serializer
  attributes :id

  has_many :form_questions
end
