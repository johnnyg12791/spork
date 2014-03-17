# This file was used to write to the yaml file for every single food the average rating for that food based on the ratings in the database.
# This was necc. when we changed the schema to include the average rating value as a part of the food table and to not compute this each time.
f = File.open("db/final_seeds.yml", "r")
write_file = File.open("db/seedFileWithRatings.txt", "w")
priorLine = ""
f.each_line do |line|
	if line.include? "restaurant_id: " # basically, if we're at a dish item in the yaml file
		matcher = /dish_name: "/.match(priorLine) # get the dish name from the last line in the yaml file
		dish_name = matcher.post_match[0..-3]
		matcher2 = /restaurant_id: /.match(line) # get the restaurant id from the current line
		rest_id = matcher2.post_match
		write_file.write(line) # write the current restaurnt_id line
		write_file.write("    num_ratings: 5" + "\n") # write that the dish has 5 ratings
		food = Food.where("restaurant_id = ? and dish_name = ?", rest_id, dish_name) # find the dish with this name in order to get the id to get all the ratings for that dish
		query = "Select avg(score) from ratings where ratable_id = '" + food[0].id.to_s() + "' and ratable_type = 'Food'" # sql query to compute average rating for the dish
		avg = ActiveRecord::Base.connection.execute(query) # execute sql query to get average rating for dish
		write_file.write("    rating: " + avg[0]["avg"].to_s() + "\n") # write the average rating column attribute into the yaml file for the dish
	else
		write_file.write(line) # otherwise, copy the yaml file normally
	end
	priorLine = line
end


