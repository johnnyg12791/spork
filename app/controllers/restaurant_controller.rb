class RestaurantController < ApplicationController
  def show
    id = params[:id]
    @restaurant = Restaurant.find_by_id(id)
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
    # @average_score = Rating.avg_rating || 0
    @average_score = 0

    #WHAT DOES THIS SQL QUERY DO? In general, you can be much clearer with Active Record
    @foods_by_rating = Food.find_by_sql(["select foods.*, pictures.file_name from foods LEFT OUTER JOIN pictures ON pictures.imageable_id = foods.id AND pictures.imageable_type = 'Food' where foods.restaurant_id = ? ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", id])
    # @foods_by_rating = Food.where(restaurant_id: @restaurant.id).order(avg_rating: desc)

    #@foods_by_rating = Food.find_by_sql(["select * from foods where foods.restaurant_id = ? ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", restaurantid])
    #foods_by_rating = Food.find_by_sql(["select foods.*, pictures.file_name from foods, pictures where foods.restaurant_id = ? AND pictures.imageable_id = foods.id ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", id])

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

    current_menu = params[:current_menu]
    @display_current_menu = true
    if(current_menu.blank?) then ## no parameter - display only current menu
      @display_current_menu = true
    elsif current_menu == "true" ## if button clicked to display current menu 
      @display_current_menu = true
    else ## case where button was clicked to display all food items ever
      @display_current_menu = false
    end

    ## IF WE EVER IMPLEMENT CATEGORIES -> Hash by categories
    # @foods = Food.where(restaurant_id: @restaurant.id).inject(Hash.new{|h, k| h[k] = []}) do |h, food| 
    #   h[food.category] << food
    # }
    if(@display_current_menu == false) then #display all food items ever
      @foods = Food.find_by_sql(["select foods.*, pictures.file_name from foods LEFT OUTER JOIN pictures ON pictures.imageable_id = foods.id AND pictures.imageable_type = 'Food' where foods.restaurant_id = ? ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", @restaurant.id])
    else
      @foods = Food.find_by_sql(["select foods.*, pictures.file_name from foods LEFT OUTER JOIN pictures ON pictures.imageable_id = foods.id AND pictures.imageable_type = 'Food' where foods.on_menu = 'true' AND foods.restaurant_id = ? ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", @restaurant.id])
    end

  end
  
  def username_from_id(id)
    @User = User.find_by_id(id)
  end

  helper_method :username_from_id

  def addDish
      dishName = params[:name] # front end validated to ensure not ""
      price = params[:price] # front end validated to ensure a real number
      description = params[:description] # potentially ""
      uploadedFile = params[:image] # potentially "" or nil
      toReviewBool = params[:reviewOrNot] # either true or false (String)
      restaurantId = params[:restaurantId]
      puts "rest ID"
      puts restaurantId
      food = Food.new(:dish_name => dishName, :price => price, :description => description, :restaurant_id => restaurantId)
      food.save()
      food_in_db = Food.where("restaurant_id = ? AND dish_name = ?", restaurantId, dishName)
      if(!uploadedFile.blank?) then
        picture = Picture.new(:file_name => uploadedFile.original_filename, :imageable_type => "Food", :imageable_id => food_in_db[0].id)
        picture.save()
        File.open(Rails.root.join('app', 'assets', 'images', 'food_items', uploadedFile.original_filename), 'wb') do |file|
          file.write(uploadedFile.read)
        end
      end

      if(toReviewBool == "true") then
        rating = params[:rating] # 1-5
        review = params[:review] # potentially ""
        rating = Rating.new(:ratable_id => food_in_db[0].id, :ratable_type => "Food", :user_id => session[:user_id], :score => rating, :comment => review)
        rating.save()
      end

      redirect_to(:action => 'menu/' + restaurantId)
  end

  def edit
    puts "edit"
    id = params[:id]
    @restaurant = Restaurant.find_by_id(id)
    if @restaurant.nil?
      raise ActionController::RoutingError.new('No such restaurant')
    end
    @foods = Food.where("restaurant_id = ?", id)


  end

  def editSelected
    
    on_menu_ids = params[:on_menu_ids]
    @restaurantId = params[:restaurantId]
    if(on_menu_ids == nil) then
      on_menu_ids = []
    end
    off_menu_ids = params[:off_menu_ids]
    if(off_menu_ids == nil) then
      off_menu_ids = []
    end
    all_ids = on_menu_ids.concat(off_menu_ids)
    @foods_to_edit = Food.find(all_ids, :order => 'on_menu')


  end

  def updateMenu
    restaurantId = params[:restaurantId]
    dish_names = params[:dish_names]
    dish_descriptions = params[:dish_descriptions]
    dish_prices = params[:dish_prices]
    dish_booleans = params[:dish_booleans]
    foodIds = params[:foodIds]
    for num in 0..dish_names.length-1
      puts num
      puts num
      puts num
      food = Food.find(foodIds[num])
      food.dish_name = dish_names[num]
      food.description = dish_descriptions[num]
      food.price = dish_prices[num]
      if(dish_booleans == "true") then
        food.on_menu = true
      else
        food.on_menu = false
      end
      food.save()
    end
    redirect_to(:action => 'edit/' + restaurantId)
  end

end
