class AddReviewedToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :reviewed, :boolean
  end
end
