class AddThresholdScoreToSyndromes < ActiveRecord::Migration[5.2]
  def change
    add_column :syndromes, :threshold_score, :float
  end
end
