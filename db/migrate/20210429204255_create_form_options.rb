class CreateFormOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :form_options do |t|
      t.boolean :value, default: nil
      t.string :text
      t.integer :order
      t.references :form_question, foreign_key: true

      t.timestamps
    end
  end
end
