class AddRequireIdToGroupsAndManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :require_id, :boolean
    add_column :group_managers, :require_id, :boolean
  end
end
