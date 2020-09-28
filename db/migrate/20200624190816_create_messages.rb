class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :title
      t.text :warning_message
      t.text :go_to_hospital_message
      t.text :feedback_message
      t.references :syndrome, foreign_key: true

      t.timestamps
    end
  end
end
