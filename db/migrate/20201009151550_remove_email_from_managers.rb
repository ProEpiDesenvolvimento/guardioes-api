class RemoveEmailFromManagers < ActiveRecord::Migration[5.2]
  def change
    remove_column :managers, :email, :string
  end
end
