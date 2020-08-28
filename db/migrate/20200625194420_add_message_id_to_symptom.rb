class AddMessageIdToSymptom < ActiveRecord::Migration[5.2]
  def change
    add_reference :symptoms, :message, foreign_key: true
  end
end
