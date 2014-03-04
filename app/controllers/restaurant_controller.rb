class RestaurantController < ApplicationController
  def show
    id = params[:id]
    @restaurant = Restaurant.find_by_id(id)
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
    
    @foods_by_rating = Food.find_by_sql(["select foods.*, pictures.file_name from foods LEFT OUTER JOIN pictures ON pictures.imageable_id = foods.id AND pictures.imageable_type = 'Food' where foods.restaurant_id = ? ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", id])

    #@foods_by_rating = Food.find_by_sql(["select * from foods where foods.restaurant_id = ? ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", restaurantid])
    
    #foods_by_rating = Food.find_by_sql(["select foods.*, pictures.file_name from foods, pictures where foods.restaurant_id = ? AND pictures.imageable_id = foods.id ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", id])

    #Todo return rating (avg of all ratings)

    respond_to do |format|
      format.json {render json: { restaurant: @restaurant, img: @hero_image }}
      format.html {render layout: true }
    end
  end


  
  def username_from_id(id)
    @User = User.find_by_id(id)
  end

  helper_method :username_from_id
end
