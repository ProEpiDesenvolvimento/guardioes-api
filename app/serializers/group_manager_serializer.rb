class GroupManagerSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :group_name, :group_permissions,
             :vigilance_email, :twitter, :require_id, :id_code_length, :app_id

  def group_permissions
    list = []
    object.groups.each do |g|
      list << { group: g.get_path(string_only=true,labled=false).join('/'), id: g.id }
    end
    list
  end
end