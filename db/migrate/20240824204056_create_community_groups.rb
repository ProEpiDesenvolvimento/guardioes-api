class CreateCommunityGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :community_groups do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :email1, null: false
      t.string :email2
      t.string :email3

      t.timestamps
    end
  end
end
