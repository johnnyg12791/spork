class RestaurantController < ApplicationController
  
  # Displays the restaurant page for the given restaurant id
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
    @average_score = 0
    # retrieves all food for the restaurant and it's dish pictures ordered by highest rating
    @foods_by_rating = Food.find_by_sql(["select foods.*, pictures.file_name from foods LEFT OUTER JOIN pictures ON pictures.imageable_id = foods.id AND pictures.imageable_type = 'Food' where foods.restaurant_id = ? ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", id])

    respond_to do |format|
      format.json {render json: { restaurant: @restaurant, img: @hero_image }}
      format.html {render layout: true }
    end
  end

  # Displays the menu page for a given restaurant
  def menu
    @restaurant = Restaurant.find_by_id(params[:id])
    if @restaurant.nil?
      raise ActionController::RoutingError.new('No such restaurant')
    end
    current_menu = params[:current_menu] # used as a parameter for page refresh if the user clicks to show all food items ever / only current menu items
    @display_current_menu = true
    if(current_menu.blank?) then ## no parameter (initial first time going to page) - display only current menu
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
    else # display only current menu items
      @foods = Food.find_by_sql(["select foods.*, pictures.file_name from foods LEFT OUTER JOIN pictures ON pictures.imageable_id = foods.id AND pictures.imageable_type = 'Food' where foods.on_menu = 'true' AND foods.restaurant_id = ? ORDER BY (select avg(score) from ratings where ratings.ratable_id = foods.id) DESC", @restaurant.id])
    end

  end
  
  def username_from_id(id)
    @User = User.find_by_id(id)
  end

  helper_method :username_from_id

  # Called after a form is submitted for adding a dish to a menu
  def addDish
      dishName = params[:name] # front end validated to ensure not ""
      price = params[:price] # front end validated to ensure a real number, may be "" if no price entered
      description = params[:description] # potentially "" if no description entered in form
      uploadedFile = params[:image] # potentially "" if no image uploaded for dish
      toReviewBool = params[:reviewOrNot] # either true or false (String)
      restaurantId = params[:restaurantId]
      food = Food.new(:dish_name => dishName, :price => price, :description => description, :restaurant_id => restaurantId)
      food.save()
      food_in_db = Food.where("restaurant_id = ? AND dish_name = ?", restaurantId, dishName)
      if(!uploadedFile.blank?) then # adds the file to the picture table and stores the jpeg in file system to retrieve
        picture = Picture.new(:file_name => uploadedFile.original_filename, :imageable_type => "Food", :imageable_id => food_in_db[0].id)
        picture.save()
        File.open(Rails.root.join('app', 'assets', 'images', 'food_items', uploadedFile.original_filename), 'wb') do |file|
          file.write(uploadedFile.read)
        end
      end
      # toReview is used to determine if the user entered a review when submitting the form
      if(toReviewBool == "true") then # add review
        rating = params[:rating] # 1-5
        review = params[:review] # potentially ""
        rating = Rating.new(:ratable_id => food_in_db[0].id, :ratable_type => "Food", :user_id => session[:user_id], :score => rating, :comment => review)
        rating.save()
      end

      redirect_to(:action => 'menu/' + restaurantId) # go back to menu page after adding dish
  end

  # Finds all of the foods for the given restaurant to display for the admin as check boxes to decide
  # which dishes to edit
  def edit
    id = params[:id]
    @restaurant = Restaurant.find_by_id(id)
    if @restaurant.nil?
      raise ActionController::RoutingError.new('No such restaurant')
    end
    @foods = Food.where("restaurant_id = ?", id)

  end

  # When the admin selects what dishes to edit, this is called to join the dishes selected from the
  # on menu dishes and the dishes selected from the off menu dishes and passes it to the view to display
  # the table form.
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

  # When the admin finishes editing the dishes in the table form, this is called to update all of the dishes
  # in the database from all of the inputs in the table form.
  def updateMenu
    # get all fields from all the dishes - the below are arrays for all of the different dishes
    restaurantId = params[:restaurantId]
    dish_names = params[:dish_names]
    dish_descriptions = params[:dish_descriptions]
    dish_prices = params[:dish_prices]
    dish_booleans = params[:dish_booleans]
    foodIds = params[:foodIds]
    for num in 0..dish_names.length-1
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

  # If the admin edits the restaurant information, the form submit comes here to update
  # the restaurant/photos in the database/file system
  def editRestaurant
    restaurantId = params[:restaurantId]
    restaurant_name = params[:name]
    restaurant_address = params[:address]
    restaurant_description = params[:description]
    restaurant_hours = params[:hours]
    photos = params[:file]

    # if the admin uploaded 1 or more photos
    if(!photos.blank?) then
      photos.each do |photo|
        picture = Picture.new(:file_name => photo.original_filename, :imageable_type => "Restaurant", :imageable_id => restaurantId )
        picture.save()
        File.open(Rails.root.join('app', 'assets', 'images', 'restaurants', photo.original_filename), 'wb') do |file|
          file.write(photo.read)
        end
      end
    end

    # updates the restaurant in the database with the new information
    restaurant = Restaurant.find(restaurantId)
    restaurant.name = restaurant_name
    restaurant.address = restaurant_address
    restaurant.description = restaurant_description
    restaurant.save()

    # updates all of the attributes in the hours table of the database with the new operating hours information
    days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    hours = Hour.where("restaurant_id = ?", restaurantId)[0]
    if(!hours) then
      hours = Hour.new()
    end
    index = 0
    days.each do |day|
      hours[day] = restaurant_hours[index]
      index = index + 1
    end
    hours.restaurant_id = restaurantId
    hours.save()
    
    redirect_to(:action => 'edit/' + restaurantId)

  end

end
