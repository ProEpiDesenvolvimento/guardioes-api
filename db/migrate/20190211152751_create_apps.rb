class CreateApps < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :app_name, null:false, default:""
      t.string :owner_country, null:false, default:""

      t.timestamps
    end
  end
end
