class GroupSerializer < ActiveModel::Serializer
  attributes :id, :description, :children_label, :parent, :managers

  def parent
    if object.parent == nil
      return nil
    end
    { name: object.description, id: object.id }
  end

  def managers
    list = []
    object.managers.each do |m|
      list << { manager: m.name, id: m.id }
    end
    list
  end
end
