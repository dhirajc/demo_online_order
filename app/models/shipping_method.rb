class ShippingMethod < ActiveRecord::Base
  belongs_to :shipping_zone
end
