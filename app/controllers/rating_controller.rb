class RatingController < ApplicationController
	def new
		#TODO: handle drinks vs food
		food_id = params[:id]
		if (Food.find_by_id(food_id).nil?)
			@rating = 0
			@food = 0
			@photos = 0
		else
			@rating = Rating.new
			@food = Food.find_by_id(food_id)
			@photos = @food.pictures
		end
	end

	def create
		# if session["user_id"].nil?
		# 	render(:action => :new, :id => params[:id])
		# else 


		@food = Food.find_by_id(params[:id])
	  	@rating = Rating.new
	  		@rating.ratable_id = params[:id]
	  		@rating.ratable_type = "food"
	  		# @rating.user_id = session["user_id"]
	  		@rating.user_id = 1
	  		@rating.type = "food1"
	  		@rating.score = params[:rating][:score]
	  		@rating.comment = params[:rating][:comment]
		  	@rating.date_time = Time.now

	   		if @rating.save
		   		flash[:notice] = "Rating successfully created!"
		     	redirect_to(:controller => "food", :action => "index", :id => @food.id) #go back to page with all pictures
	   		else
	    	 	render(:action => :new, :id => @food.id)
	 	 end
	 # end
	end
end



