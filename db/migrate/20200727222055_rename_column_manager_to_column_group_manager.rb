class RenameColumnManagerToColumnGroupManager < ActiveRecord::Migration[5.2]
  def change
    rename_column :manager_group_permissions, :manager_id, :group_manager_id
  end
end
