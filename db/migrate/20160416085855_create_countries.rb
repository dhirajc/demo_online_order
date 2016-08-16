class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :abbreviation
      t.references :shipping_zone, index: true, foreign_key: true
      t.boolean :active

      t.timestamps null: false
    end
  end
end
