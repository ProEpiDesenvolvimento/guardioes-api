class CreateVbeAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :vbe_answers do |t|
      t.string :data
      t.references :vbe_form, foreign_key: true

      t.timestamps
    end
  end
end
