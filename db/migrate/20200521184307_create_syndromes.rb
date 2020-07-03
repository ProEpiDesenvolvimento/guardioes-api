class CreateSyndromes < ActiveRecord::Migration[5.2]
  def change
    create_table :syndromes do |t|
      t.string :description
      t.string :details

      t.timestamps
    end
  end
end
