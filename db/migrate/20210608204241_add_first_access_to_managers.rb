class AddFirstAccessToManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :managers, :first_access, :boolean, default: true
  end
end
