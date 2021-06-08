class AddTraceabilityToGroupManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :created_by, :string
    add_column :group_managers, :updated_by, :string
    add_column :group_managers, :deleted_by, :string
  end
end
