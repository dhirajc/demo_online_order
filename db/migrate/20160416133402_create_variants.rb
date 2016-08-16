class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.references :food, index: true, foreign_key: true
      t.string :sku
      t.string :name
      t.decimal :price
      t.decimal :cost
      t.datetime :deleted_at
      t.boolean :master
      t.references :inventory, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
