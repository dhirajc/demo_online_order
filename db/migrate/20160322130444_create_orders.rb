class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status, :default => "Pending"
      t.integer :total
      t.integer :vat
      t.integer :delivery_cost
      t.integer :user_id
      t.string :transaction_id
      t.string :invoice
      t.integer :pickup_time

      t.timestamps null: false
    end
  end
end
