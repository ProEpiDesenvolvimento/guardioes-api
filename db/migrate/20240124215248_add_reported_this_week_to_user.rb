class AddReportedThisWeekToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :reported_this_week, :boolean, default: false
  end
end
