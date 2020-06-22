class AddAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :identification_code, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
  end
end
