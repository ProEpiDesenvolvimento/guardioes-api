class CreateDoses < ActiveRecord::Migration[5.2]
    def change
      create_table :doses do |t|
        t.date :date, null: false
        t.integer :dose, null: false
        t.references :vaccine, null: false, foreign_key: true
        t.references :user, null: false, foreign_key: true
  
        t.timestamps
      end
    end
  end