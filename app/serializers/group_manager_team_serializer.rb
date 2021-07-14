class GroupManagerTeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :app_id

  has_one :group_manager
  has_one :permission
end