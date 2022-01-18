class AddFieldsToCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :app, foreign_key: true
  end
end
