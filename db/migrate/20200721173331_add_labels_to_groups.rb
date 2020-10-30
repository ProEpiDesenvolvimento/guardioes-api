class AddLabelsToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :children_label, :string
  end
end
