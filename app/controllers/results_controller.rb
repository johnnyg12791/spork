require 'net/http'

class ResultsController < ApplicationController

	NUM_ITEMS_PER_PAGE = 12
	NUM_ITEMS_PER_ROW = 6
	NUM_ROWS_PER_PAGE = 2

	def search

		@render = 'default'
		if params[:render] then
			@render = params[:render]
		end

		@search_loc = params[:search_loc]
		@search_lat = params[:search_lat]
		@search_long = params[:search_long]
		if @search_loc != nil
			address = @search_loc.gsub(/\s/, "+")
			uri = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&sensor=false")
			http = Net::HTTP.get_response(uri)
			results = JSON.parse(http.body)
			#formatted_address = results["results"][0]["formatted_address"]
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

		@search_distance = 5
		if params[:search_distance] then
			@search_distance = params[:search_distance]
		end

		@restaurants = Restaurant.find_by_sql(["SELECT DISTINCT restaurants.* from foods, restaurants WHERE
			(3959*acos(cos(radians(?))*cos(radians(restaurants.latitude))*cos(radians(restaurants.longitude)-radians(?)) + 
			sin(radians(?))*sin(radians(restaurants.latitude)))) < ? AND ((lower(restaurants.name) like ? OR 
			lower(restaurants.description) like ?) OR (lower(foods.dish_name) like ? OR lower(foods.description) like ?)) AND 
			foods.restaurant_id = restaurants.id LIMIT 60", @search_lat, @search_long, @search_lat, @search_distance, "%#{@search_item}%", 
			"%#{@search_item}%", "%#{@search_item}%", "%#{@search_item}%"])

		@dishes = Food.find_by_sql(["SELECT DISTINCT foods.* from foods, restaurants WHERE 
			(3959*acos(cos(radians(?))*cos(radians(restaurants.latitude))*cos(radians(restaurants.longitude)-radians(?)) + 
			sin(radians(?))*sin(radians(restaurants.latitude)))) < ? AND ((lower(restaurants.name) like ? OR 
			lower(restaurants.description) like ?) OR (lower(foods.dish_name) like ? OR lower(foods.description) like ?)) AND 
			foods.restaurant_id = restaurants.id ORDER BY foods.rating DESC NULLS LAST LIMIT 60", @search_lat, @search_long, @search_lat, 
			@search_distance, "%#{@search_item}%", "%#{@search_item}%", "%#{@search_item}%", "%#{@search_item}%"])

		if @render == 'json' then
			render :json => {:restaurants => @restaurants, :dishes => @dishes}
		elsif @render == 'partials_only' then
			render :partial => "shared/item_squares", :locals => {:dishes => @dishes}
		end

	end

end