class Order < ActiveRecord::Base
  include AASM

  has_many :order_items, :dependent => :destroy
  #has_many :foods,through: :order_items
  has_many   :shipments
  has_many   :invoices
  has_many   :completed_invoices,   -> { where(state: ['authorized', 'paid']) },  class_name: 'Invoice'
  has_many   :authorized_invoices,  -> { where(state: 'authorized') },      class_name: 'Invoice'
  has_many   :paid_invoices      ,  -> { where(state: 'paid') },            class_name: 'Invoice'
  has_many   :canceled_invoices   , ->  { where(state: 'canceled') }  ,     class_name: 'Invoice'
 
  
  belongs_to :user
  belongs_to   :ship_address, class_name: 'Address'
  belongs_to   :bill_address, class_name: 'Address'

  
  before_validation :set_email, :set_number
  after_create      :save_order_number
  before_save       :update_tax_rates

  attr_accessor :total, :sub_total, :taxed_total
  
  validates :user_id,     presence: true
  validates :email,       presence: true,
                          format:   { with: CustomValidators::Emails.email_validator } 
  NUMBER_SEED = 1001001001000
  CHARACTERS_SEED = 21

  aasm column: :state do
    state :in_progress, initial: true
    state :complete
    state :paid 
    state :canceled  


    event :complete do
      transitions to: :complete, from: :in_progress
    end

    event :pay, after: :mark_items_paid do
      transitions to: :paid, from: [:in_progress, :complete]
    end  

  end

  def mark_items_paid
    order_items.map(&:pay!)
  end

  def transaction_time
    calculated_at || Timze.zone.now
  end

  def first_invoice_amount
    return '' if completed_invoices.empty? && canceled_invoices.empty?
    completed_invoices.last ? completed_invoices.last.amount : canceled_invoices.last.amount
  end

  def status
    return 'not processed' if invoices.empty?
    invoices.last.state
  end

  def cancel_unshipped_order(invoice)
    transaction do
      self.update_attributes(active: false)
      invoice.cancel_authorized_payment
    end
  end

  def self.between(start_time, end_time)
    where("orders.completed_at >= ? AND orders.completed_at <= ?", start_time, end_time)
  end

  def self.order_by_completion
    order('orders.completed_at asc')
  end

  def self.finished
    where({:orders => { :state => ['complete', 'paid']}})
  end

  def self.find_myaccount_details
    includes([:completed_invoices, :invoices])
  end

  def add_cart_item( item, state_id = nil)
    self.save! if self.new_record?
    tax_rate_id = state_id ? item.variant.product.tax_rate(state_id) : nil
    item.quantity.times do
      oi =  OrderItem.create(
          :order        => self,
          :variant_id   => item.variant.id,
          :price        => item.variant.price)
      self.order_items.push(oi)
    end
  end

  # def capture_invoice(invoice)
  #   payment = invoice.capture_payment({})
  #   self.pay! if payment.success
  #   payment
  # end

  # def create_invoice(credit_card, charge_amount, args, credited_amount = 0.0)
  #   transaction do
  #     new_invoice = create_invoice_transaction(credit_card, charge_amount, args, credited_amount)
  #     if new_invoice.succeeded?
  #       remove_user_store_credits

  #       if Settings.uses_resque_for_background_emails
  #         Resque.enqueue(Jobs::SendOrderConfirmation, self.id, new_invoice.id)
  #       else
  #         Notifier.order_confirmation(self.id, new_invoice.id).deliver rescue puts( 'do nothing...  dont blow up over an order conf email')
  #       end
  #     end
  #     new_invoice
  #   end
  # end

  def order_complete!
    self.state = 'complete'
    self.completed_at = Timze.zone.now
    update_inventory
  end
  def find_total(force = false)
    self.find_sub_total
    self.total  = self.sub_total
  end

  def find_sub_total
    self.total = 0.0
    order_items.each do |item|
      self.total = self.total + item.price if !item.price.nil?
    end
    self.sub_total = self.total
  end

  # def taxed_amount
  #   #(get_taxed_total - total).round_at( 2 )
  # end

  # def get_taxed_total
  #   taxed_total || find_total
  # end

  # Turns out in order to determine the order.total_price correctly (to include coupons and deals and all the items)
  #     it is much easier to multiply the tax times to whole order's price.  This should work for most use cases.  It
  #     is rare that an order going to one location would ever need 2 tax rates
  #
  # For now this method will just look at the first item's tax rate.  In the future tax_rate_id will move to the order object
  #
  # @param none
  # @return [Float] tax rate  10.5% === 10.5
  # def order_tax_percentage
  #   (!order_items.blank? && order_items.first.tax_rate.try(:percentage)) ? order_items.first.tax_rate.try(:percentage) : 0.0
  # end  



  def add_items(variant, quantity, state_id = nil)
    self.save! if self.new_record?
    #tax_rate_id = state_id ? variant.product.tax_rate(state_id) : nil
    quantity.times do
      self.order_items.push(OrderItem.create(:order => self,:variant_id => variant.id, :price => variant.price))
    end
  end

  # remove the variant from the order items in the order
  #
  # @param [Variant] variant to add
  # @param [Integer] final quantity that should be in the order
  # @return [none]
  def remove_items(variant, final_quantity)

    current_qty = 0
    items_to_remove = []
    self.order_items.each_with_index do |order_item, i|
      if order_item.variant_id == variant.id
        current_qty = current_qty + 1
        items_to_remove << order_item.id  if (current_qty - final_quantity) > 0
      end
    end
    OrderItem.where(id: items_to_remove).map(&:destroy) unless items_to_remove.empty?
    self.order_items.reload
  end
  
  def self.id_from_number(num)
    num.to_i(CHARACTERS_SEED) - NUMBER_SEED
  end

  ## finds the Order from the orders number.  Is more optimal than the normal rails find by id
  #      because if calculates the order's id which is indexed
  #
  # @param [String]  represents the order.number
  # @return [Order]
  def self.find_by_number(num)
    find(id_from_number(num))##  now we can search by id which should be much faster
  end

  ## This method is called when the order transitions to paid
  #   it will add the number of variants pending to be sent to the customer
  #
  # @param none
  # @return [none]
  def update_inventory
    self.order_items.each { |item| item.variant.add_pending_to_customer }
  end

  # variant ids in the order.
  #
  # @param [none]
  # @return [Integer] all the variant_id's in the order
  def variant_ids
    order_items.collect{|oi| oi.variant_id }
  end


  # if the order has a shipment this is true... else false
  #
  # @param [none]
  # @return [Boolean]
  def has_shipment?
    shipments_count > 0
  end

  def self.include_checkout_objects
    includes([{ship_address: :state},
              {bill_address: :state}])
  end
private
  def item_prices
    order_items.collect{|item| item.adjusted_price }
  end

  # Called before validation.  sets the email address of the user to the order's email address
  #
  # @param none
  # @return [none]
  def set_email
    self.email = user.email if user_id
  end

  # Called before validation.  sets the order number, if the id is nil the order number is bogus
  #
  # @param none
  # @return [none]
  def set_number
    return set_order_number if self.id
    self.number = (Time.now.to_i).to_s(CHARACTERS_SEED)## fake number for friendly_id validator
  end

  # sets the order number based off constants and the order id
  #
  # @param none
  # @return [none]
  def set_order_number
    self.number = (NUMBER_SEED + id).to_s(CHARACTERS_SEED)
  end


  # Called after_create.  sets the order number
  #
  # @param none
  # @return [none]
  def save_order_number
    set_order_number
    save
  end

  # Called before save.  If the ship address changes the tax rate for all the order items needs to change appropriately
  #
  # article.title  #=> "Title"
  # article.title = "New Title"
  # article.title_changed? #=> true
  # @param none
  # @return [none]
  def update_tax_rates
    # if ship_address_id_changed?
    #   # set_beginning_values
    #   tax_time = completed_at? ? completed_at : Time.zone.now
    #   order_items.each do |item|
    #     rate = item.variant.product.tax_rate(self.ship_address.state_id, tax_time)
    #     if rate && item.tax_rate_id != rate.id
    #       item.tax_rate = rate
    #       item.save
    #     end
    #   end
    # end
  end

  def create_invoice_transaction(credit_card, charge_amount, args, credited_amount = 0.0)
    invoice_statement = Invoice.generate(self.id, charge_amount, credited_amount)
    invoice_statement.save
    invoice_statement.authorize_payment(credit_card, args)#, options = {})
    invoices.push(invoice_statement)
    if invoice_statement.succeeded?
      self.order_complete! #complete!
      self.save
    else
      #role_back
      invoice_statement.errors.add(:base, 'Payment denied!!!')
      invoice_statement.save

    end
    invoice_statement
  end  
end