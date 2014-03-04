#MenuPages_GetRestaurants
#Get all the SF restaurant name --> url combinations

import urllib2
from bs4 import BeautifulSoup
import csv
import unicodedata


'''
There are 6 different neighborhoods:

haight-castro-noe-valley
soma-mission
richmond
sunset
marina-heights
downtown-waterfront

Each with up to...15? different pages (100 restuarants per page)
http://sanfrancisco.menupages.com/restaurants/soma-mission/all-neighborhoods/all-cuisines/1/
...
http://sanfrancisco.menupages.com/restaurants/soma-mission/all-neighborhoods/all-cuisines/10/
'''

base_url = "http://sanfrancisco.menupages.com/restaurants/"
neighborhoods = ["haight-castro-noe-valley", "soma-mission", "richmond", "sunset", "marina-heights", "downtown-waterfront"]


def main():
  url_list = build_url_list()
  restaurant_dict = get_restaurant_dict(url_list)

def build_url_list():
  urls = []
  for neighborhood in neighborhoods:
    urls.append(base_url + neighborhood + "/all-neighborhoods/all-cuisines/")
    for i in range(1, 15):
      urls.append(base_url + neighborhood + "/all-neighborhoods/all-cuisines/" + str(i))
  return urls

def get_restaurant_dict(url_list):
  all_restaurants_dict = {}
  for url in url_list:
    web_page = urllib2.urlopen(url).read()
    soup = BeautifulSoup(web_page)
    restaurant_table = soup.find('table', attrs={'class': 'search-results'})
    if (restaurant_table != None):
      restaurant_list = restaurant_table.findAll('tr')
      restaurant_dict = ParseRestaurantList(restaurant_list[1:])
      for key, value in restaurant_dict.items():
        all_restaurants_dict[key] = ["http://sanfrancisco.menupages.com" + value[0] + "menu", value[1]]
      print len(all_restaurants_dict)
  return all_restaurants_dict  

def ParseRestaurantList(restaurant_list):
  restaurant_dict = {}
  for restaurant in restaurant_list:
    restaurant_string = str(restaurant)

    #Get the AllMenus Restaurant URL (for scraping menu)
    url_start_index = restaurant_string.find("href=\"") + len("href=\"")
    url_end_index = restaurant_string.find("\">", url_start_index) 
    url = restaurant_string[url_start_index:url_end_index]
    #Get the Restaurant Name
    name_start_index = restaurant_string.find("</span>", url_end_index) + len("</span>")
    name_end_index = restaurant_string.find("</a>", name_start_index)
    restaurant_name = restaurant_string[name_start_index:name_end_index]
    #Get the restaurant address
    address_start_index = name_end_index + len("</a>")
    address_end_index = restaurant_string.find("|", address_start_index)
    address = restaurant_string[address_start_index:address_end_index].strip()

    restaurant_dict[restaurant_name] = [url, address]

  return restaurant_dict



if __name__ == '__main__':
  main()