require 'net/http'

class ResultsController < ApplicationController

	NUM_ITEMS_PER_PAGE = 12
	NUM_ITEMS_PER_ROW = 6
	NUM_ROWS_PER_PAGE = 2

# Called when the user searches for a given food item / location.
	def search
		@render = 'default'
		if params[:render] then
			@render = params[:render]
		end

		@search_loc = params[:search_loc] # address user searched for
		@search_lat = params[:search_lat] # the user's current location latitude. If the address searched for fails to give a new latitude, this is used instead
		@search_long = params[:search_long] #  the user's current longitude - same use case as above
		if @search_loc != nil
			address = @search_loc.gsub(/\s/, "+")
			uri = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&sensor=false")
			http = Net::HTTP.get_response(uri)
			results = JSON.parse(http.body)
			# if address yielded results, override the user's current location coordinates with the searched-for-latitude/longitude
			if results["status"] != "ZERO_RESULTS"
				@search_lat = results["results"][0]["geometry"]["location"]["lat"]
				@search_long = results["results"][0]["geometry"]["location"]["lng"]
			end
		end

		@search_item = ""
		if params[:search_item] then
			@search_item = params[:search_item]
		end
		@search_item.downcase

		# the default search distance (max circular radius of a restaurant from the searched for location) is 5 unless the user specified a search radius
		@search_distance = 5
		if params[:search_distance] then
			@search_distance = params[:search_distance]
		end

		# Based on the Haversine Formula found on google maps API. The below is a Sql query to find all restaurants that has dishes with a dish name containing the search query or a dish description containing the search query,
		# (independent of case), or the restaurant name or description contains the search query, and the restaurant must be within the circular search
		# radius of the searched for location.
		@restaurants = Restaurant.find_by_sql(["SELECT DISTINCT restaurants.* from foods, restaurants WHERE
			(3959*acos(cos(radians(?))*cos(radians(restaurants.latitude))*cos(radians(restaurants.longitude)-radians(?)) + 
			sin(radians(?))*sin(radians(restaurants.latitude)))) < ? AND ((lower(restaurants.name) like ? OR 
			lower(restaurants.description) like ?) OR (lower(foods.dish_name) like ? OR lower(foods.description) like ?)) AND 
			foods.restaurant_id = restaurants.id LIMIT 60", @search_lat, @search_long, @search_lat, @search_distance, "%#{@search_item}%", 
			"%#{@search_item}%", "%#{@search_item}%", "%#{@search_item}%"])

		# All of the dishes returned below are ordered by average rating from highest to lowest.
		# Similar to the above query, but returns the dishes that are within restaurants within the given distance radius that has a dish name or description
		# with the search query, or its restaurant name / description has the search query.
		@dishes = Food.find_by_sql(["SELECT DISTINCT foods.* from foods, restaurants WHERE 
			(3959*acos(cos(radians(?))*cos(radians(restaurants.latitude))*cos(radians(restaurants.longitude)-radians(?)) + 
			sin(radians(?))*sin(radians(restaurants.latitude)))) < ? AND ((lower(restaurants.name) like ? OR 
			lower(restaurants.description) like ?) OR (lower(foods.dish_name) like ? OR lower(foods.description) like ?)) AND 
			foods.restaurant_id = restaurants.id ORDER BY foods.rating DESC NULLS LAST LIMIT 60", @search_lat, @search_long, @search_lat, 
			@search_distance, "%#{@search_item}%", "%#{@search_item}%", "%#{@search_item}%", "%#{@search_item}%"])

		if @render == 'json_only' then
			render :json => {:restaurants => @restaurants, :dishes => @dishes}
		elsif @render == 'partials_only' then
			render :partial => 'shared/item_squares', :locals => {:dishes => @dishes, :with_json => false}
		elsif @render == 'partials_and_json_only' then
			render :partial => 'shared/item_squares', :locals => {:dishes => @dishes, :with_json => true, :restaurants => @restaurants}
		end
		# else search.html.erb (the default) will be rendered

	end

end