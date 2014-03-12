#this is a script for downloading pictures via google image search

import os
import urllib
import urllib2
import json as simplejson
from bs4 import BeautifulSoup

RESTAURANT_FILE = "restaurants.csv"

#got up to Ace_of_sandwhiches

def main():
  restaurant_names = getRestaurantNames()
  last_restaurant_taken = "Taipan"
  start_scraping = False

  for restaurant in restaurant_names:
    if(last_restaurant_taken in restaurant and start_scraping == False):
      start_scraping = True
    if(start_scraping):
      #print restaurant
      url_restaurant = urllib.quote_plus(restaurant)
      url = 'https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=' + url_restaurant + '&imgtype=photo'
      request = urllib2.Request(url, None, {'Referer': 'http://www.my-ajax-site.com' })
      response = urllib2.urlopen(request)

      # Process the JSON string.
      results = simplejson.load(response)
      filename = "../app/assets/images/restaurants/" + restaurant.replace(" ", "_")
      print filename
      #raw_input("")
      for index, item in enumerate(results["responseData"]["results"]):
        picture_url = item["url"]
        f = open(filename + "_" + str(index) + ".jpg", 'wb')
        f.write(urllib.urlopen(picture_url).read())
        f.close()

        #raw_input("")




def getRestaurantNames():
  names = []
  with open(RESTAURANT_FILE) as f:
    content = f.readlines()
    for line in content:
      end_index = line.find(":")
      names.append(str(line[:end_index]) + "_Palo_Alto")
  return names


if __name__ == "__main__":
  main()