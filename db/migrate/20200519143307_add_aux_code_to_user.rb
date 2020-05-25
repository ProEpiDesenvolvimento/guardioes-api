class AddAuxCodeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :aux_code, :string
  end
end
