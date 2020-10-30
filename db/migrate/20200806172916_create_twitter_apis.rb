class CreateTwitterApis < ActiveRecord::Migration[5.2]
  def change
    create_table :twitter_apis do |t|

      t.timestamps
    end
  end
end
