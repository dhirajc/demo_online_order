class AddFieldsToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :price, :decimal
    add_column :order_items, :total, :decimal
    add_column :order_items, :state, :string
    add_reference :order_items, :shipment, index: true, foreign_key: true
  end
end
