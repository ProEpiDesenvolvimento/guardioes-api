class AddPasswordChangedToManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :managers, :password_changed, :boolean, default: false
  end
end
