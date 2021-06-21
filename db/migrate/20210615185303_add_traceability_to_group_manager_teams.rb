class AddTraceabilityToGroupManagerTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :group_manager_teams, :created_by, :string
    add_column :group_manager_teams, :updated_by, :string
    add_column :group_manager_teams, :deleted_by, :string
  end
end
