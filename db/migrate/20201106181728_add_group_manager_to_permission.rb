class AddGroupManagerToPermission < ActiveRecord::Migration[5.2]
  def change
    add_reference :permissions, :group_manager, foreign_key: true
  end
end
