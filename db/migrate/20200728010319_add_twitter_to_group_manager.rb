class AddTwitterToGroupManager < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :twitter, :string
  end
end
