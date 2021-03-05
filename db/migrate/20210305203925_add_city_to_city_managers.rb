class AddCityToCityManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :city_managers, :city, :string
  end
end
