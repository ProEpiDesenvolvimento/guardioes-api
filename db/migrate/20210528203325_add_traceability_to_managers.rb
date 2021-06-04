class AddTraceabilityToManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :managers, :created_by, :string
    add_column :managers, :updated_by, :string
    add_column :managers, :deleted_by, :string
  end
end
