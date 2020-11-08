class AddManagerToPermission < ActiveRecord::Migration[5.2]
  def change
    add_reference :permissions, :manager, foreign_key: true
  end
end
