class AddGodataCredentialsToGroupManager < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :username_godata, :text, default: ""
    add_column :group_managers, :password_godata, :text, default: ""
  end
end
