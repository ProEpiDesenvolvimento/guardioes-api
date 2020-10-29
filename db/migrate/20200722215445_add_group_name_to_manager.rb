class AddGroupNameToManager < ActiveRecord::Migration[5.2]
  def change
    add_column :managers, :group_name, :string
  end
end
