class RemoveRumorFromSurveys < ActiveRecord::Migration[5.2]
  def change
    remove_column :surveys, :event_title
    remove_column :surveys, :event_description
    remove_column :surveys, :event_confirmed_cases_number
    remove_column :surveys, :event_confirmed_deaths_number
  end
end
