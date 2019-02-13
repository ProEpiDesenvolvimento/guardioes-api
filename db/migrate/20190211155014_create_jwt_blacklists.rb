class CreateJwtBlacklists < ActiveRecord::Migration[5.2]
  def change
    create_table :jwt_blacklist do |t|
      t.string :jti, null: false
      t.timestamps
    end
    add_index :jwt_blacklist, :jti
  end
end
