class RemoveTwitterAndIdCodeFromGroups < ActiveRecord::Migration[5.2]
    def change
        remove_column :groups, :twitter, :string
        remove_column :groups, :require_id, :boolean
        remove_column :groups, :id_code_length, :integer
    end
  end
  