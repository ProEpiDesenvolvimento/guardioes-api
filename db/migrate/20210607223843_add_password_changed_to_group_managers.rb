class AddPasswordChangedToGroupManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :password_changed, :boolean, default: false
  end
end
