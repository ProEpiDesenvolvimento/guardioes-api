class RenameManagerToGroupManager < ActiveRecord::Migration[5.2]
  def change
    rename_table :managers, :group_managers
  end
end
