class RemovePermissionIdFromManager < ActiveRecord::Migration[5.2]
  def change
    remove_column :managers, :permission_id, :integer
  end
end
