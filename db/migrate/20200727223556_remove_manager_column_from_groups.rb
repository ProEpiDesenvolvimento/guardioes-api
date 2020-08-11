class RemoveManagerColumnFromGroups < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :manager_id
  end
end
