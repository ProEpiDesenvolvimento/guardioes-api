class CreateEventForms < ActiveRecord::Migration[5.2]
  def change
    create_table :event_forms do |t|
      t.string :title
      t.text :description
      t.text :data
      t.references :group_manager, foreign_key: true

      t.timestamps
    end
  end
end
