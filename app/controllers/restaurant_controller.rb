class RestaurantController < ApplicationController
  def show
    @restaurant = Restaurant.find_by_id(params[:id])
    if @restaurant.nil?
      puts "cannot find"
      #TODO: render an alternate, safe, cannot-find page
      return
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


  
  def username_from_id(id)
    @User = User.find_by_id(params[:id])
  end

  helper_method :username_from_id
end
