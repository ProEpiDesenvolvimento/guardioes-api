class AddAuxCodeToCityManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :city_managers, :aux_code, :string
  end
end
