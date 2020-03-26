class CreateHouseholds < ActiveRecord::Migration[5.2]
  def change
    create_table :households do |t|
      t.string :description
      t.date :birthdate
      t.string :country
      t.string :gender
      t.string :race
      t.string :kinship
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
