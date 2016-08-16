class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.references :user, index: true, foreign_key: true
      t.references :cart, index: true, foreign_key: true
      t.integer :quantity
      t.boolean :active
      t.references :item_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
