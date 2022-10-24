class VbeFormSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :data

  def data
    return object.get_data
  end
end
