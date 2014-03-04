class ResultsController < ApplicationController
	def search
		@render = false;
		getDishesAndRestaurants()	

	end

	def getDishesAndRestaurants()
		if(@render == nil)
			@render = params[:render]
		end
		@search_loc = params[:searchbar]
		@lat = params[:latbar]
		@lon = params[:lngbar]
		if @search_loc != nil
			address = @search_loc.gsub(/\s/, "+")
			uri = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&sensor=false")
			http = Net::HTTP.get_response(uri)
			results = JSON.parse(http.body)
			#formatted_address = results["results"][0]["formatted_address"]
			if results["status"] != "ZERO_RESULTS"
				@lat = results["results"][0]["geometry"]["location"]["lat"]
				@lon = results["results"][0]["geometry"]["location"]["lng"]
			end
		end
		@item_search = params[:itemsearch]

		distance = 5
		if(params[:distance]) then
			distance = params[:distance]
		end

		@restaurants = Restaurant.find_by_sql(["SELECT distinct restaurants.id, restaurants.name, restaurants.description, restaurants.address, restaurants.latitude, restaurants.longitude, restaurants.hours from foods, restaurants WHERE (3959*acos(cos(radians(?))*cos(radians(restaurants.latitude))*cos(radians(restaurants.longitude)-radians(?)) + sin(radians(?))*sin(radians(restaurants.latitude)))) < ? AND ((lower(restaurants.name) like ? OR lower(restaurants.description) like ?) OR (lower(foods.dish_name) like ? OR lower(foods.description) like ?)) AND foods.restaurant_id = restaurants.id", @lat, @lon, @lat, distance, "%#{@item_search.downcase}%", "%#{@item_search.downcase}%", "%#{@item_search.downcase}%", "%#{@item_search.downcase}%"])
		@dishes = Food.find_by_sql(["SELECT distinct foods.id, foods.dish_name, foods.price, foods.description, foods.size, foods.calories, foods.nutrition, foods.presentation from foods, restaurants WHERE (3959*acos(cos(radians(?))*cos(radians(restaurants.latitude))*cos(radians(restaurants.longitude)-radians(?)) + sin(radians(?))*sin(radians(restaurants.latitude)))) < ? AND ((lower(restaurants.name) like ? OR lower(restaurants.description) like ?) OR (lower(foods.dish_name) like ? OR lower(foods.description) like ?)) AND foods.restaurant_id = restaurants.id", @lat, @lon, @lat, distance, "%#{@item_search.downcase}%", "%#{@item_search.downcase}%", "%#{@item_search.downcase}%", "%#{@item_search.downcase}%"])
		@dishes = @dishes.sort_by{|dish| 
				if((Rating.exists? :ratable_id => dish.id) == nil)
					0
				else 
					Rating.average(:score, :conditions => {:ratable_id => dish.id}) 
				end
			}
		@restaurants = @restaurants.map do |rest| {:restaurant => rest, :pictures => rest.pictures} end
		@dishes = @dishes.map do |dish| {:dish => dish, :pictures => dish.pictures} end	
		if(@render) then
			render(:json => {:restaurants => @restaurants, :dishes => @dishes})
		end
	end


    def get_restaurants
   	    lat = params[:lat]
 	    lon = params[:lon]
 	    @restaurants = Restaurant.where("(3959*acos(cos(radians(?))*cos(radians(latitude))*cos(radians(longitude)-radians(?)) + sin(radians(?))*sin(radians(latitude)))) < 5", lat, lon, lat)
 	    @restaurants_with_pics = @restaurants.map do |rest| {:restaurant => rest, :pictures => rest.pictures} end
 

 	    render(:json => @restaurants_with_pics)

 	end

 	def get_pictures
 		restaurant_id = params[:id]
 		puts restaurant_id
 		puts restaurant_id
 		puts restaurant_id
 		@pictures = Restaurant.find(restaurant_id).pictures
 		render(:json => @pictures)
 	end



end




