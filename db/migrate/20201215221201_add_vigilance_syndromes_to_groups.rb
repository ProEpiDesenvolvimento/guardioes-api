class AddVigilanceSyndromesToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :vigilance_syndromes, :text, default: ''
  end
end
