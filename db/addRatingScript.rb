# This file was used to add 5 ratings to the yaml file for every food item in the yaml file to occupy the database with rating data

f = File.open("db/rating.txt", "w")

foods = Food.all()
f.write("ratings:" + "\n")
f.write("  -" + "\n")
# specified descriptions in rails console - 5 descriptions for 5 different reviews to cycle over
foods.each do |food|
	descriptions.each do |description|
		# for every food, write 5 reviews to the yaml file with the associated food id and a RANDOM score from 1-5
		id = food.id.to_s()
		score = rand(5).to_s()

		f.write("    ratable_id: " + id + "\n")
		f.write("    ratable_type: Food" + "\n")
		f.write("    score: " + score + "\n")
		f.write("    comment: " + description + "\n")
		f.write("    user_id: 1" + "\n")
		f.write("  -" + "\n")
	end
end