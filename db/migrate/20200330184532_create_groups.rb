class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :description
      t.string :kind
      t.string :details
      t.references :manager, foreign_key: true

      t.timestamps
    end
  end
end
