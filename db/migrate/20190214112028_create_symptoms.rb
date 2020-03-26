class CreateSymptoms < ActiveRecord::Migration[5.2]
  def change
    create_table :symptoms do |t|
      t.string :description
      t.string :code
      t.integer :priority
      t.text :details
      t.references :app, foreign_key: true

      t.timestamps
    end
  end
end
