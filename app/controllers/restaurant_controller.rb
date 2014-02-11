class RestaurantController < ApplicationController
  def show
    @restaurant = Restaurant.find_by_id(params[:id])
    @restaurant_images = @restaurant.pictures
    @hero_image = @restaurant_images.where(picture_type: "banner").first.file_name

    @num_reviews = 0;
    @ratings = @restaurant.foods.ratings
    
    #todo return rating (avg of all ratings)

    respond_to do |format|
      format.json {render json: { restaurant: @restaurant, img: @hero_image }}
      format.html {render layout: true }
    end
    
  end
end
