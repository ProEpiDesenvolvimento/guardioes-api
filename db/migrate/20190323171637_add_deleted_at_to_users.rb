class AddDeletedAtToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end

  def down
    remove_index :users, :deleted_at
    remove_column :users, :deleted_at
  end
end
