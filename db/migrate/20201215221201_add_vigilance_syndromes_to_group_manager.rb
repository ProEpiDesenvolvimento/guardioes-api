class AddVigilanceSyndromesToGroupManager < ActiveRecord::Migration[5.2]
  def change
    add_column :group_managers, :vigilance_syndromes, :text, default: ''
  end
end
