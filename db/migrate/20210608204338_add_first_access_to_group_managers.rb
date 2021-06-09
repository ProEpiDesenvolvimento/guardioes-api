class AddFirstAccessToGroupManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :first_access, :boolean, default: true
  end
end
