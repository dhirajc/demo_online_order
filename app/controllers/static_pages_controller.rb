class StaticPagesController < ApplicationController
	def home
		@categories = Category.all
	end


	def about_us

	end
end
