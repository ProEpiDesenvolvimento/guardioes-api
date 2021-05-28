class AddTraceabilityToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :created_by, :string
    add_column :admins, :updated_by, :string
    add_column :admins, :deleted_by, :string
  end
end
