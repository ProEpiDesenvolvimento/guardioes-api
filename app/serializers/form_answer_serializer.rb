class FormAnswerSerializer < ActiveModel::Serializer
  attributes :id

  has_one :form
  has_one :form_question
  has_one :form_option
  has_one :user
end
