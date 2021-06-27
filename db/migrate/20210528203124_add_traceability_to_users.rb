class AddTraceabilityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :created_by, :string
    add_column :users, :updated_by, :string
    add_column :users, :deleted_by, :string
  end
end
