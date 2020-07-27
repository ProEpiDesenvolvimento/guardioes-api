class CreatePreRegisters < ActiveRecord::Migration[5.2]
  def change
    create_table :pre_registers do |t|
      t.string :cnpj
      t.string :phone
      t.string :organization_kind
      t.string :state
      t.string :company_name
      t.references :app, foreign_key: true

      t.timestamps
    end
  end
end
