class AddFirstAccessToCityManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :city_managers, :first_access, :boolean, default: true
  end
end
