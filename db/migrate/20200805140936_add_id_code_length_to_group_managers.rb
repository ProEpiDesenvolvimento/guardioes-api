class AddIdCodeLengthToGroupManagers < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :id_code_length, :int
  end
end
