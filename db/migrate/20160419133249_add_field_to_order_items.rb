class AddFieldToOrderItems < ActiveRecord::Migration
  def change
    add_reference :order_items, :variant, index: true, foreign_key: true
  end
end
