class AddResetPasswordToManager < ActiveRecord::Migration[5.2]
  def change
    add_column :managers, :aux_code, :string
    add_column :admins, :aux_code, :string
    add_column :group_managers, :aux_code, :string
  end
end
