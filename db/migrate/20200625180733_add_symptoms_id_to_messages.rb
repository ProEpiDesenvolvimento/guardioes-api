class AddSymptomsIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :symptom, foreign_key: true
  end
end
