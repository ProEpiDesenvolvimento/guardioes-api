class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :category, foreign_key: true

    remove_column :categories, :user_id, :integer
  end
end
