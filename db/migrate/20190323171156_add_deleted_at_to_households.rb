class AddDeletedAtToHouseholds < ActiveRecord::Migration[5.2]
  def up
    add_column :households, :deleted_at, :datetime
    add_index :households, :deleted_at
  end

  def down
    remove_index :households, :deleted_at
    remove_column :households, :deleted_at
  end
end
