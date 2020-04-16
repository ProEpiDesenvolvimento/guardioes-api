class AddDeletedAtToGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :deleted_at, :datetime
    add_index :groups, :deleted_at
  end
end
