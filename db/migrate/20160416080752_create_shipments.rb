class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.references :order, index: true, foreign_key: true
      t.references :shipping_method, index: true, foreign_key: true
      t.references :address, index: true, foreign_key: true
      t.string :tracking
      t.string :number
      t.string :state
      t.string :shipped_at
      t.boolean :active

      t.timestamps null: false
    end
  end
end
