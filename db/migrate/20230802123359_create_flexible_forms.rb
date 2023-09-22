class CreateFlexibleForms < ActiveRecord::Migration[5.2]
  def change
    create_table :flexible_forms do |t|
      t.string :title
      t.text :description
      t.string :form_type
      t.references :group_manager, foreign_key: true

      t.timestamps
    end
  end
end
