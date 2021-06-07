class AddPasswordChangedToCityManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :city_managers, :password_changed, :boolean, default: false
  end
end
