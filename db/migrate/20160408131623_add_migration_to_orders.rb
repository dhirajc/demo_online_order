class AddMigrationToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :number, :string
    add_column :orders, :ip_address, :string
    add_column :orders, :email, :string
    add_column :orders, :state, :string
    add_reference :orders, :bill_address, index: true, foreign_key: true
    add_reference :orders, :ship_address, index: true, foreign_key: true
    add_reference :orders, :coupon, index: true, foreign_key: true
    add_column :orders, :active, :boolean
    add_column :orders, :shipped, :boolean
    add_column :orders, :shipments_count, :string
    add_column :orders, :calculated_at, :datetime
    add_column :orders, :completed_at, :datetime
    add_column :orders, :credited_amount, :decimal
  end
end
