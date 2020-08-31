class AddIdCodeLengthToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :id_code_length, :int
  end
end
