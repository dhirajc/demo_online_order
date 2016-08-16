class FoodsController < ApplicationController
	# require "will_paginate-bootstrap"
	#require 'will_paginate/array' 
	# def index
	# 	#@category = Category.find(params[:format])
	# 	#raise "hello"
	# 	#@foods = Food.active.includes(:variants)
	# 	#form_info
	# end
	def category
		
	    products = Food.active.includes(:variants)
	    #products = Food.active.includes(:variants)
	    #raise "hello"
	    product_types = nil
	    if params[:id].present? && product_type = Category.find_by_id(params[:id])
	    	#product_types = product_type.self_and_descendants.map(&:id)
	        product_types = product_type
	    end
	    if product_types
	      @products = products.where(category_id: product_types).paginate(:page => params[:page], :per_page => 5)
	    else
	      @products = products.paginate(:page => params[:page], :per_page => 5)
	    end
		form_info
	end
	
	def show
		@food = Food.active.find(params[:id])
		form_info
		@cart_item.variant_id = @food.active_variants.first.try(:id)
	end

private
  def form_info
    @cart_item = CartItem.new
  end

  def featured_product_types
    [ProductType::FEATURED_TYPE_ID]
  end
end
