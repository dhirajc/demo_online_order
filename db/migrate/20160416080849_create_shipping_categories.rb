class CreateShippingCategories < ActiveRecord::Migration
  def change
    create_table :shipping_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
