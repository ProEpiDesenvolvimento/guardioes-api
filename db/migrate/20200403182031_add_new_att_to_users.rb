class AddNewAttToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :risk_group, :boolean
  end
end
