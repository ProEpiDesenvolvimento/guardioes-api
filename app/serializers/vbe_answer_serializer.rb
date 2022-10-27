class VbeAnswerSerializer < ActiveModel::Serializer
  attributes :id, :data

  belongs_to :vbe_form

  def data
    return object.get_data
  end
end
