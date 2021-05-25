class AddDeletedAtToCityManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :city_managers, :deleted_at, :datetime
    add_index :city_managers, :deleted_at
  end
end
