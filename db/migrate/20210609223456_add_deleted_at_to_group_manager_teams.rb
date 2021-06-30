class AddDeletedAtToGroupManagerTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :group_manager_teams, :deleted_at, :datetime
    add_index :group_manager_teams, :deleted_at
  end
end
