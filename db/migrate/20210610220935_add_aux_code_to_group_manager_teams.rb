class AddAuxCodeToGroupManagerTeams < ActiveRecord::Migration[5.2]
  def change
    add_column :group_manager_teams, :aux_code, :string
  end
end
