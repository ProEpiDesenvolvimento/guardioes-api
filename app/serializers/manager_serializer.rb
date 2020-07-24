class ManagerSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :group_name, :group_permissions

  def group_permissions
    list = []
    object.groups.each do |g|
      list << { group: g.description, id: g.id }
    end
    list
  end
end