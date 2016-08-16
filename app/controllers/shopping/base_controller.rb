class Shopping::BaseController < ApplicationController
  helper_method :session_order, :session_order_id

private

  def next_form_url(order)
    next_form(order) || shopping_orders_url
  end

  def next_form(order)
    # if cart is empty
    if session_cart.shopping_cart_items.empty?
      flash[:notice] = I18n.t('do_not_have_anything_in_your_cart')
      return foods_url
    ## If we are insecure
    elsif not_secure?
      session[:return_to] = shopping_orders_url
      return new_user_session_path()
    elsif session_order.ship_address_id.nil?
      return shopping_addresses_url()
    end
  end

  def session_order
    find_or_create_order
  end

  def not_secure?
    !current_user
  end

  def find_or_create_order
    return @session_order if @session_order
    if session[:order_id]
      @session_order = current_user.orders.find(session[:order_id])     
    else
      create_order
    end
    @session_order
  end

  def create_order
      @session_order = current_user.orders.create(:number       => Time.now.to_i,
                                                :ip_address   => request.env['REMOTE_ADDR'],
                                                :bill_address => current_user.billing_address  )
    add_new_cart_items(session_cart.shopping_cart_items)
    session[:order_id] = @session_order.id
  end

  def add_new_cart_items(items)
    items.each do |item|
      @session_order.add_items(item.variant,item.quantity)
    end
  end

end