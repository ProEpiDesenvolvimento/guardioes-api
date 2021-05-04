class CreateFormAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :form_answers do |t|
      t.references :form, foreign_key: true
      t.references :form_question, foreign_key: true
      t.references :form_option, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
