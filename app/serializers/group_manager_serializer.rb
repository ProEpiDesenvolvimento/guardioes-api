class GroupManagerSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :group_name, :group_permissions

  def group_permissions
    list = []
    object.groups.each do |g|
      list << { group: g.get_path(string_only=true,labled=false).join('/'), id: g.id }
    end
    list
  end
end