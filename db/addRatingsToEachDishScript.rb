f = File.open("db/final_seeds.yml", "r")
write_file = File.open("db/seedFileWithRatings.txt", "w")
priorLine = ""
f.each_line do |line|
	if line.include? "restaurant_id: "
		matcher = /dish_name: "/.match(priorLine)
		dish_name = matcher.post_match[0..-3]
		matcher2 = /restaurant_id: /.match(line)
		rest_id = matcher2.post_match
		write_file.write(line)
		write_file.write("    num_ratings: 5" + "\n")
		food = Food.where("restaurant_id = ? and dish_name = ?", rest_id, dish_name)
		query = "Select avg(score) from ratings where ratable_id = '" + food[0].id.to_s() + "' and ratable_type = 'Food'"
		avg = ActiveRecord::Base.connection.execute(query)
		write_file.write("    rating: " + avg[0]["avg"].to_s() + "\n")
	else
		write_file.write(line)
	end
	priorLine = line
end


