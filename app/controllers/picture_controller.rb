class PictureController < ApplicationController
	def new
		if session["user_id"].nil?
			@user_id = 0
			@photo = 0
		else
			@user_id = session["user_id"]
			@photo = Picture.new
		end
	end

    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "file_name"
    t.string   "picture_type"
    t.datetime "date_time"
    t.datetime "created_at"
    t.datetime "updated_at"

	def create
		if session["user_id"].nil?
			render(:action => :new)
		else
			@food_id = params[:id]
			@photo = Picture.new
			@photo.imageable_type = "food"
			@photo.imageable_id = @food_id
			@photo.file_name = params[:photo][:upload].original_filename
			@photo.date_time = Time.now
			name = @photo[:file_name]
		    directory = "assets/images/"
		    path = File.join(directory, name)
		    File.open(path, "wb") { |f| f.write(params[:photo][:upload].read) }

		    if (@photo.save())
				redirect_to(:controller => "food", :action => "index", :id => @food_id)
			else 
				render(:action => :new)
			end
		end
	end
end
