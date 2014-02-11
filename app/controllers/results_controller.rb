class ResultsController < ApplicationController
	def search
		
		#@query = params[:query]
		#@foods = Food.filter(@query)
		#@drinks = Drink.filter(@query)

		@search_loc = params[:searchbar]
		@item_search = params[:itemsearch]
		puts "ITEMMMMMMMM"
		puts @item_search
		puts @item_search
		puts @item_search
		if @item_search != nil && @item_search.length != 0
			puts "INSIIIIDEEE"
			@restaurants = Restaurant.select("id").where("lower(name) like ? OR lower(description) like ?", "%#{@item_search.downcase}%", "%#{@item_search.downcase}%")
			@dishes = []
			numRestaurants = @restaurants.length
			if numRestaurants != 0
				for i in 0..numRestaurants
					@dishes.concat(Food.where("restaurant_id = ?", @restaurants[i].id))
				end
			end
			@dishes.concat(Food.where("lower(dish_name) like ? OR lower(description) like ?", "%#{@item_search.downcase}%", "%#{@item_search.downcase}%"))
			@dishes.uniq
			puts @dishes
		end
		# @results = foods + drinks
	end

    def get_restaurants
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