class RestaurantController < ApplicationController
  def show
    @restaurant = Restaurant.find_by_id(params[:id])
    if @restaurant.nil?
      raise ActionController::RoutingError.new('No such restaurant')
    end

    begin
      @restaurant_images = @restaurant.pictures
      @hero_image = @restaurant_images.where(picture_type: "banner").first.file_name
    rescue
      @hero_image = "test.jpg"
    end

    @ratings = Rating.where(ratable_id: @restaurant.foods)
    @num_reviews = @ratings.count
    
    #Todo return rating (avg of all ratings)

    respond_to do |format|
      format.json {render json: { restaurant: @restaurant, img: @hero_image }}
      format.html {render layout: true }
    end
  end

  def menu
    @restaurant = Restaurant.find_by_id(params[:id])
    if @restaurant.nil?
      raise ActionController::RoutingError.new('No such restaurant')
    end

    ## IF WE EVER IMPLEMENT CATEGORIES -> Hash by categories
    # @foods = Food.where(restaurant_id: @restaurant.id).inject(Hash.new{|h, k| h[k] = []}) do |h, food| 
    #   h[food.category] << food
    # }

    @foods = Food.where(restaurant_id: @restaurant.id)
  end

  helper_method :username_from_id
end
