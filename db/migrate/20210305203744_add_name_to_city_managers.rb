class AddNameToCityManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :city_managers, :name, :string
  end
end
