class FoodController < ApplicationController

# Used to show the food page for a given food id. Displays the pictures and in the view, allows user to add a rating for the dish
	def index
		@food = Food.find_by_id(params[:id])
		if (@food.nil?)
      raise ActionController::RoutingError.new('Food not found')
		else
			@restaurant = Restaurant.find_by_id(@food.restaurant_id)
			@pictures = @food.pictures

			@ratings = Rating.where(ratable_id: @food.id)
      order = @ratings.order('score desc')
      @rating_best = order.first
      @rating_worst = order.last
		end
	end

	def new
		if session["user_id"].nil?
			@user_id = 0
			@food = 0
			@photo = 0
		else
			@user_id = session["user_id"]
			@food = Food.new
			@photo = Picture.new
		end
	end

	def create
		if session["user_id"].nil?
			render(:action => :new)
		else
			@user_id = session["user_id"]
			@photo = Picture.new
			@photo.imageable_type = "food"
			@photo.imageable_id = @food_id
			@photo.file_name = params[:photo][:upload].original_filename
			@photo.date_time = Time.now

			name = @photo[:file_name]
		    directory = "public/images/"
		    path = File.join(directory, name)
		    File.open(path, "wb") { |f| f.write(params[:photo][:upload].read) }

		    if (@photo.save())
				redirect_to(:controller => "photos", :action => "index", :id => @user_id)
			else 
				render(:action => :new)
			end
		end
	end

# Called when the user submits the add a rating form to add images to the database/file system, and add the rating to the database
	def addRating
    uploadedFile = params[:image] # potentially "" or nil
    foodId = params[:foodId]
    #if the user uploaded an image of the food:
    if(uploadedFile != "" and uploadedFile != nil) then
      picture = Picture.new(:file_name => uploadedFile.original_filename, :imageable_type => "Food", :imageable_id => foodId, :date_time => Time.now)
      picture.save()
      File.open(Rails.root.join('app', 'assets', 'images', 'food_items', uploadedFile.original_filename), 'wb') do |file|
        file.write(uploadedFile.read)
      end
    end
    rating = params[:rating] # 1-5
    review = params[:review] # potentially ""
    rating = Rating.new(:ratable_id => foodId, :ratable_type => "Food", :user_id => session[:user_id], :score => rating, :comment => review)
    rating.save()

    redirect_to(:action => 'index/' + foodId)
	end
end
