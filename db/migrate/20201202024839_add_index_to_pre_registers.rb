class AddIndexToPreRegisters < ActiveRecord::Migration[5.2]
  def change
    add_index :pre_registers, :email, :unique => true
  end
end
