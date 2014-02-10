class RestaurantController < ApplicationController
  def show
    @restaurant = Restaurant.first
    @banner_img_urls = @restaurant.pictures.where(type: "banner")
    
    @num_reviews = 0;
    #todo return rating (avg of all ratings)
    
  end
end
