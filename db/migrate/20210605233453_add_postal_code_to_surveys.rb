class AddPostalCodeToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :postal_code, :string
  end
end
