class CreateShippingZones < ActiveRecord::Migration
  def change
    create_table :shipping_zones do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
