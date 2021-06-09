class AddFirstAccessToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :first_access, :boolean, default: true
  end
end
