class CreateFlexibleAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :flexible_answers do |t|
      t.references :flexible_form_version, foreign_key: true
      t.jsonb :data
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
