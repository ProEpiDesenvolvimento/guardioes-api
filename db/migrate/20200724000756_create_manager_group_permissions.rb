class CreateManagerGroupPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :manager_group_permissions do |t|
      t.references :manager, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
