

f = File.open("db/rating.txt", "w")

foods = Food.all()
f.write("ratings:" + "\n")
f.write("  -" + "\n")

foods.each do |food|
	descriptions.each do |description|
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