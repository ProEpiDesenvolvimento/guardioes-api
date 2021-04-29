class FormQuestionSerializer < ActiveModel::Serializer
  attributes :id, :kind, :text, :order

  has_many :form_options
  has_one :form
end
