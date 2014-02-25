class ResultsController < ApplicationController
	def search
		
		#@query = params[:query]
		#@foods = Food.filter(@query)
		#@drinks = Drink.filter(@query)

		@search_loc = params[:searchbar]
		@item_search = params[:itemsearch]
		puts @search_loc
		puts @item_search
		if @item_search != nil && @item_search.length != 0
			@restaurants = Restaurant.select("id").where("lower(name) like ? OR lower(description) like ?", "%#{@item_search.downcase}%", "%#{@item_search.downcase}%")
			@dishes = []
			numRestaurants = @restaurants.length
			if numRestaurants != 0
				for i in 0..numRestaurants-1
					@dishes = @dishes.concat(Food.where("restaurant_id = ?", @restaurants[i].id))
				end
			end
			@dishes = @dishes.concat(Food.where("lower(dish_name) like ? OR lower(description) like ?", "%#{@item_search.downcase}%", "%#{@item_search.downcase}%"))
			@dishes = @dishes.uniq
			@dishes = @dishes.sort_by{|dish| 
				if((Rating.exists? :ratable_id => dish.id) == nil)
					0
				else 
					Rating.average(:score, :conditions => {:ratable_id => dish.id}) 
				end
			}
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




