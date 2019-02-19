class CreateSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :surveys do |t|
      t.references :user, foreign_key: true
      t.references :household, foreign_key: true
      t.float :latitude
      t.float :longitude
      t.date :bad_since
      t.boolean :had_traveled
      t.string :where_had_traveled
      t.text :symptom
      t.string :event_title
      t.text :event_description
      t.boolean :event_confirmed_cases
      t.integer :event_confirmed_cases_number
      t.boolean :event_confirmed_deaths
      t.integer :event_confirmed_deaths_number
      t.string :street
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
