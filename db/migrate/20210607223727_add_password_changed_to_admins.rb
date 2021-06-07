class AddPasswordChangedToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :password_changed, :boolean, default: false
  end
end
