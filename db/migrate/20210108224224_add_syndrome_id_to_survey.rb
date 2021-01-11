class AddSyndromeIdToSurvey < ActiveRecord::Migration[5.2]
  def change
    add_reference :surveys, :syndrome, foreign_key: true
  end
end
