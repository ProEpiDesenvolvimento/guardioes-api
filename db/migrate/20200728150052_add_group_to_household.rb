class AddGroupToHousehold < ActiveRecord::Migration[5.2]
  def change
    add_column :households, :group_id, :integer
  end
end
