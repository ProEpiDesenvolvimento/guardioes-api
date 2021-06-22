class GroupManagerTeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :group_manager_id, :app_id

end