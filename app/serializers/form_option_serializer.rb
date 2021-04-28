class FormOptionSerializer < ActiveModel::Serializer
  attributes :id, :value, :text, :order
  has_one :form_question
end
