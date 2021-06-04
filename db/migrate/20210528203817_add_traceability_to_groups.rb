class AddTraceabilityToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :created_by, :string
    add_column :groups, :updated_by, :string
    add_column :groups, :deleted_by, :string
  end
end
