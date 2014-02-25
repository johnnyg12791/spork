class FoodController < ApplicationController
	def index
		food_id = params[:id]
		if (Food.find_by_id(food_id).nil?)
			@food = 0
		else
			@food = Food.find_by_id(food_id)
			@pictures = @food.pictures
			# @ratings = Rating.where(ratable_id: @food)
			# @avg_rating = @food.get_avg_rating
		end
	end
end
