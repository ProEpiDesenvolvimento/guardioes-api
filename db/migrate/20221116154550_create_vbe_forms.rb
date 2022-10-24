class CreateVbeForms < ActiveRecord::Migration[5.2]
  def change
    create_table :vbe_forms do |t|
      t.string :title
      t.string :description
      t.string :data

      t.timestamps
    end
  end
end
