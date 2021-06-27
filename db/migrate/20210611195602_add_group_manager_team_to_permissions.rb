class AddGroupManagerTeamToPermissions < ActiveRecord::Migration[5.2]
  def change
    add_reference :permissions, :group_manager_team, foreign_key: true
  end
end
