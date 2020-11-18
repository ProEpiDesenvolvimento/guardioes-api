class AddAppIdToSyndromes < ActiveRecord::Migration[5.2]
  def change
    add_column :syndromes, :app_id, :bigint, :default => 1, foreign_key: true
  end
end
