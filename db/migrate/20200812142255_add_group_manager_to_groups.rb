class AddGroupManagerToGroups < ActiveRecord::Migration[5.2]
    def change
      add_column :groups, :group_manager_id, :integer
    end
  end
  