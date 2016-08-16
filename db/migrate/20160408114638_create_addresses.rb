class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :address_type, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :addressable_type
      t.references :addressable, index: true, foreign_key: true
      t.string :address1
      t.string :address2
      t.string :city
      t.references :state, index: true, foreign_key: true
      t.string :state_name
      t.string :zip_code
      t.string :phone
      t.string :alternative_phone
      t.boolean :default
      t.boolean :billing_default
      t.boolean :active
      t.references :country, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
