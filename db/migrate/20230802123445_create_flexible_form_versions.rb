class CreateFlexibleFormVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :flexible_form_versions do |t|
      t.integer :version
      t.text :notes
      t.references :flexible_form, foreign_key: true
      t.jsonb :data
      t.datetime :version_date

      t.timestamps
    end
  end
end
