class AddAdminToPermission < ActiveRecord::Migration[5.2]
  def change
    add_reference :permissions, :admin, foreign_key: true
  end
end
