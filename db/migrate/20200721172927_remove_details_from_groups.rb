class RemoveDetailsFromGroups < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :details, :string
  end
end
