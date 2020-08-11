class RemoveKindFromGroups < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :kind, :string
  end
end
