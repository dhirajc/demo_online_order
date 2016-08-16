class CreateShippingMethods < ActiveRecord::Migration
  def change
    create_table :shipping_methods do |t|
      t.string :name
      t.references :shipping_zone, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
