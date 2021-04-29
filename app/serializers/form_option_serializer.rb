class FormOptionSerializer < ActiveModel::Serializer
  attributes :id, :value, :text, :order

  has_one :form_question
  has_one :form

  def form
    id = object.form_question.form_id
    return Form.where(id: id)
  end
end
