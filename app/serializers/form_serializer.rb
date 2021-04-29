class FormSerializer < ActiveModel::Serializer
  attributes :id

  has_many :form_questions
  has_one :group_manager

  #def form_questions
  #  object.form_questions.map do |question|
  #    obj = question.form_options

  #    obj.map do |option|
  #      puts option.to_json
  #    end
  #    return obj
  #  end
  # end
end
