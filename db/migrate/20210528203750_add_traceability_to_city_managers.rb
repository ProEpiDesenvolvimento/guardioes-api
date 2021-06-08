class AddTraceabilityToCityManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :city_managers, :created_by, :string
    add_column :city_managers, :updated_by, :string
    add_column :city_managers, :deleted_by, :string
  end
end
