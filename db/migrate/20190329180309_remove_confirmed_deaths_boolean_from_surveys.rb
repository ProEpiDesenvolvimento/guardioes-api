class RemoveConfirmedDeathsBooleanFromSurveys < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :surveys, :event_confirmed_cases
    remove_column :surveys, :event_confirmed_deaths
  end

  def self.down
    add_column :surveys, :event_confirmed_cases, :boolean
    add_column :surveys, :event_confirmed_deaths, :boolean
  end
end
