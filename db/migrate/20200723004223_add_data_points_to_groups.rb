class AddDataPointsToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :code, :string
    add_column :groups, :address, :string
    add_column :groups, :cep, :string
    add_column :groups, :phone, :string
    add_column :groups, :email, :string
  end
end
