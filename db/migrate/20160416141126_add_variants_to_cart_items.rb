class AddVariantsToCartItems < ActiveRecord::Migration
  def change
    add_reference :cart_items, :variant, index: true, foreign_key: true
  end
end
