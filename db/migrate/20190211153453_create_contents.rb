class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.string :title, null:false, default:""
      t.text :body, null:false, default:""
      t.string :type, null:false, default:""
      t.references :app, foreign_key: true

      t.timestamps
    end
  end
end
