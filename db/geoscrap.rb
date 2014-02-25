require "net/http"
require "net/https"
require "uri"
require "json"
require "rubygems"


f = File.open("db/seeds.yml", "r")
seed_file = File.open("db/new_seeds_file.yml", "a")
done = false
start = false;
f.each_line do |line|

	if line.include? "Howie's Artisan Pizza"
		start = true
		next
	end
	if start == true
		if done == true
			seed_file.write(line)
		else
			if line == "foods:"
				done = true
				seed_file.write(line)
			elsif line.include? "address:"
				matcher = /address: /.match(line)
				address = matcher.post_match.gsub(/\s/, "+")
				address[0] = ''
				address[address.length-1] = ''
				address[address.length-1] = ''
				uri = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&sensor=false")
				http = Net::HTTP.get_response(uri)
				results = JSON.parse(http.body)
				puts http.body
				formatted_address = results["results"][0]["formatted_address"]
				lat = results["results"][0]["geometry"]["location"]["lat"]
				longitude = results["results"][0]["geometry"]["location"]["lng"]
				seed_file.write("\taddress: \"" + formatted_address + "\"" + "\n")
				seed_file.write("\tlatitude: " + lat.to_s + "\n")
				seed_file.write("\tlongitude: " + longitude.to_s + "\n") 
				sleep(3)
			else
				seed_file.write(line)
			end

		end

	end
end
f.close
