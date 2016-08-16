class Shopping::OrdersController < Shopping::BaseController
  before_filter :authenticate_user!
  # GET /shopping/orders
  ### The intent of this action is two fold
  #
  # A)  if there is a current order redirect to the process that
  # => needs to be completed to finish the order process.
  # B)  if the order is ready to be checked out...  give the order summary page.
  #
  ##### THIS METHOD IS BASICALLY A CHECKOUT ENGINE
  def index
    @order = find_or_create_order
    #raise "hello"
    if f = next_form(@order)
      redirect_to f
    else
      expire_all_browser_cache
      form_info
    end
  end


  #  add checkout button
  def checkout
    #current or in-progress otherwise cart (unless cart is empty)
    order = find_or_create_order
    @order = session_cart.add_items_to_checkout(order) # need here because items can also be removed
    redirect_to next_form_url(order)
  end

  # POST /shopping/orders
  def update
    @order = find_or_create_order
    @order.ip_address = request.remote_ip

    #@credit_card ||= ActiveMerchant::Billing::CreditCard.new(cc_params)

    address = @order.bill_address.cc_params

    if !@order.in_progress?
      session_cart.mark_items_purchased(@order)
      session[:order_id] = nil
      flash[:error] = I18n.t('the_order_purchased')
      redirect_to myaccount_order_url(@order)
    else
      #raise "hi"
       expire_all_browser_cache
       session_cart.mark_items_purchased(@order)
       session[:last_order] = @order.number
       redirect_to( confirmation_shopping_order_url(@order) ) and return
      render :action => 'index'
    end
  end

  def confirmation
    @tab = 'confirmation'
    if session[:last_order].present? && session[:last_order] == params[:id]
      session[:last_order] = nil
      @order = Order.where(number: params[:id]).includes({order_items: :variant}).first
      render :layout => 'application'
    else
      session[:last_order] = nil
      if current_user.finished_orders.present?
        redirect_to myaccount_order_url( current_user.finished_orders.last )
      elsif current_user
        redirect_to myaccount_orders_url
      end
    end
  end
  private

  def customer_confirmation_page_view
    @tab && (@tab == 'confirmation')
  end

  def form_info
    #@credit_card ||= ActiveMerchant::Billing::CreditCard.new()
   # @order.credited_total
  end

  def require_login
    if !current_user
      session[:return_to] = shopping_orders_url
      redirect_to( new_user_session_url() ) and return
    end
  end

end
