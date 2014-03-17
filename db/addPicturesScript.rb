# This file was used to add all of the .jpg files in the images/restaurants folder (retrieved by google image API script)
# to the yaml file to preoccupy the database

seed_file = File.open("db/final_seeds.yml", "a")

images = Dir.entries("app/assets/images/restaurants/") # gets all image names
images.delete_at(0) # delete .
images.delete_at(0) # delete ..
images.each do |image|
	puts image
	# all images fit the format restaurantName_imgNumber.jpg. Ex: 4290_Bistro_&_Bar_Palo_Alto_0.jpg.
	matcher = /_Palo_Alto_[0-9].jpg/.match(image) 
	restaurant_name = matcher.pre_match # 4290_Bistro_&_Bar
	restaurant_name = restaurant_name.gsub("_", " ") # 4290 Bistro & Bar
	restaurant = Restaurant.where("name = ?", restaurant_name)[0] # get associated restaurant from database
	if restaurant == nil then # some images correspond to restaurants not in database, so skip these
		next
	end
	restaurant_id = restaurant.id
	# write the pictures and to the yaml file with the associated restaurant id, filename, and attribute values
	seed_file.write('    file_name: "' + image + '"' + "\n")
	seed_file.write('    picture_type: "banner"' + "\n")
	seed_file.write("    imageable_id: " + restaurant_id.to_s() + "\n")
	seed_file.write('    imageable_type: "Restaurant"' + "\n")
	seed_file.write("  -" + "\n")
end