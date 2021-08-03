class AddFirstAccessToGroupManagerTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :group_manager_teams, :first_access, :boolean, default: true
  end
end
