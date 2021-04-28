class FormQuestionSerializer < ActiveModel::Serializer
  attributes :id, :type, :text, :active, :order
  has_one :form
end
