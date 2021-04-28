class CreateFormQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :form_questions do |t|
      t.string :type
      t.string :text
      t.integer :order
      t.references :form, foreign_key: true

      t.timestamps
    end
  end
end
