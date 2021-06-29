class UpdateRequireId < ActiveRecord::Migration[5.2]
  def change
    change_column :group_managers, :require_id, :string
  end
end
