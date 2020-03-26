class CreateRumors < ActiveRecord::Migration[5.2]
  def change
    create_table :rumors do |t|
      t.string :title
      t.text :description
      t.integer :confirmed_cases
      t.integer :confirmed_deaths

      t.timestamps
    end
  end
end
