class AddMessageIdToSyndrome < ActiveRecord::Migration[5.2]
  def change
    add_reference :syndromes, :message, foreign_key: true
  end
end
