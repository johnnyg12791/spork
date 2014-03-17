require "net/http"
require "net/https"
require "uri"
require "json"
require "rubygems"

# A scraping script got us all of the addresses for all restaurants in Palo Alto, but they weren't geocoded. This script geocoded all of the
# address in the yaml file, and wrote to the yaml file the latitude and longtitude values obtained by making an HTTP request to google maps
# the "Howie's Artisan Pizza" line is because I had to append to the file numerous times because google maps would disconnect me for too many http requests in a short
# amount of time

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
				# get the address, make an HTTP request to google maps api
				matcher = /address: /.match(line)
				address = matcher.post_match.gsub(/\s/, "+")
				address[0] = ''
				address[address.length-1] = ''
				address[address.length-1] = ''
				uri = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&sensor=false")
				http = Net::HTTP.get_response(uri)
				results = JSON.parse(http.body)
				puts http.body
				# write the formatted address since it is nicer than what is currently there
				formatted_address = results["results"][0]["formatted_address"]
				lat = results["results"][0]["geometry"]["location"]["lat"]
				longitude = results["results"][0]["geometry"]["location"]["lng"]
				# write the latitude and longitude for the given address - geocoded!
				seed_file.write("\taddress: \"" + formatted_address + "\"" + "\n")
				seed_file.write("\tlatitude: " + lat.to_s + "\n")
				seed_file.write("\tlongitude: " + longitude.to_s + "\n") 
				sleep(3) # used to not make google maps SUPER mad for so many requests per second
			else
				seed_file.write(line) # if not dealing with a restaurant address, copy the file normally
			end

		end

	end
end
f.close
