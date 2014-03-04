class FoodController < ApplicationController
	def index
		food_id = params[:id]
		if (Food.find_by_id(food_id).nil?)
			@food = 0
		else
			@food = Food.find_by_id(food_id)
			@pictures = @food.pictures
			# @ratings = Rating.where(ratable_id: @food)
			# @avg_rating = @food.get_avg_rating
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
end
