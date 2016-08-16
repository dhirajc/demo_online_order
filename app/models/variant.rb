class Variant < ActiveRecord::Base
  belongs_to :food
  #belongs_to :inventory

  validates :price,       presence: true
  validates :food_id,  presence: true
  validates :sku,         presence: true,       length: { maximum: 255 }

  def quantity_purchaseable(admin_purchase = false)
    admin_purchase ? (quantity_available - ADMIN_OUT_OF_STOCK_QTY) : (quantity_available - OUT_OF_STOCK_QTY)
  end

  def quantity_purchaseable_if_user_wants(this_number_of_items, admin_purchase = false)
    (quantity_purchaseable(admin_purchase) < this_number_of_items) ? quantity_purchaseable(admin_purchase) : this_number_of_items
  end

end
