class ResultsController < ApplicationController
	def search
		@query = params[:query]
		@foods = Food.filter(@query)
		@drinks = Drink.filter(@query)
		# @results = foods + drinks
	end
end