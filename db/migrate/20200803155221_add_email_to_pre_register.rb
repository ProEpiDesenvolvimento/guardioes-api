class AddEmailToPreRegister < ActiveRecord::Migration[5.2]
  def change
    add_column :pre_registers, :email, :string
  end
end
