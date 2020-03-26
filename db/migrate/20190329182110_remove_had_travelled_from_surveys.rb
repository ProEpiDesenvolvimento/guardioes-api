class RemoveHadTravelledFromSurveys < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :surveys, :had_traveled
    remove_column :surveys, :where_had_traveled

    add_column :surveys, :traveled_to, :string
  end

  def self.down
    add_column :surveys, :had_traveled, :boolean
    add_column :surveys, :where_had_traveled, :string

    remove_column :surveys, :traveled_to
  end
end
