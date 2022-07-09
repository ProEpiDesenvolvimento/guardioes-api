class AddGroupManagerToContents < ActiveRecord::Migration[5.2]
  def change
    add_reference :contents, :group_manager, foreign_key: true
  end
end
