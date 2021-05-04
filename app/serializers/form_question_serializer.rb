class FormQuestionSerializer < ActiveModel::Serializer
  attributes :id, :kind, :text, :order, :form_options

  has_many :form_options
  has_one :form
end
