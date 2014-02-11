class ResultsController < ApplicationController
	def search
		
		#@query = params[:query]
		#@foods = Food.filter(@query)
		#@drinks = Drink.filter(@query)

		@search_loc = params[:searchbar]
		@item_search = params[:itemsearch]


		# @results = foods + drinks
	end

    def getRestaurants
 		#render :nothing => true
   	    lat = params[:lat]
 	    lon = params[:lon]
 	    puts lat
 	    puts lon
 	    #@restaurants = Restaurant.all()
 	    @restaurants = Restaurant.where("(3959*acos(cos(radians(?))*cos(radians(latitude))*cos(radians(longitude)-radians(?)) + sin(radians(?))*sin(radians(latitude)))) < 50", lat, lon, lat)
 	    #@restaurants = Restaurant.find(1)
 	    render(:json => @restaurants)
  	
 	end
end