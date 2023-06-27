class CreateEventAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :event_answers do |t|
      t.jsonb :data
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
