class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



  validates :firstname, :presence => true
  validates :lastname, :presence => true

  has_many :orders, dependent: :destroy

  has_many    :addresses,       dependent: :destroy,       as: :addressable

  has_one     :default_billing_address,   -> { where(billing_default: true, active: true) },
                                          as:         :addressable,
                                          class_name: 'Address'

  has_many    :billing_addresses,         -> { where(active: true) },
                                          as:         :addressable,
                                          class_name: 'Address'

  has_one     :default_shipping_address,  -> { where(default: true, active: true) },
                                          as:         :addressable,
                                          class_name: 'Address'

  has_many    :shipping_addresses,       -> { where(active: true) },
                                          as:         :addressable,
                                          class_name: 'Address'
  has_many     :orders
  has_many     :finished_orders,           -> { where(state: ['complete', 'paid']) },  class_name: 'Order'
  has_many    :user_roles,                dependent: :destroy
  has_many    :roles,                     through: :user_roles
  
  has_many    :carts,                     dependent: :destroy

  has_many    :cart_items
  has_many    :shopping_cart_items, -> { where(active: true, item_type_id: ItemType::SHOPPING_CART_ID) }, class_name: 'CartItem'
  has_many    :wish_list_items,     -> { where(active: true, item_type_id: ItemType::WISH_LIST_ID) },     class_name: 'CartItem'
  has_many    :saved_cart_items,    -> { where(active: true, item_type_id: ItemType::SAVE_FOR_LATER) },   class_name: 'CartItem'
  has_many    :purchased_items,     -> { where(active: true, item_type_id: ItemType::PURCHASED_ID) },     class_name: 'CartItem'
  has_many    :deleted_cart_items,  -> { where( active: false) }, class_name: 'CartItem'
 
  
  accepts_nested_attributes_for :addresses, :user_roles

  # Returns the default billing address if it exists.   otherwise returns the shipping address
  #
  # @param [none]
  # @return [ Address ]
  def billing_address
    default_billing_address ? default_billing_address : shipping_address
  end

  # Returns the default shipping address if it exists.   otherwise returns the first shipping address
  #
  # @param [none]
  # @return [ Address ]
  def shipping_address
    default_shipping_address ? default_shipping_address : shipping_addresses.first
  end
  def current_cart
    carts.last
  end

end
