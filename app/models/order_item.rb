class OrderItem < ActiveRecord::Base
		belongs_to :food
		belongs_to :order
		belongs_to :variant

		validates :variant_id,  :presence => true
		validates :order_id,    :presence => true
end
