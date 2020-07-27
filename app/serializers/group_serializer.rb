class GroupSerializer < ActiveModel::Serializer
  attributes :id, :description, :children_label, :parent, :group_managers, :twitter

  def parent
    if object.parent == nil
      return nil
    end
    { name: object.parent.description, id: object.parent.id }
  end

  def group_managers
    list = []
    object.group_managers.each do |m|
      list << { group_manager: m.name, id: m.id }
    end
    list
  end

  def twitter
    object.get_twitter
  end
end
