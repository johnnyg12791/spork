#AllMenu_GetRestaurants
#We are going to compile website urls here

import urllib2
from bs4 import BeautifulSoup
import csv
import unicodedata

#URL = ("http://www.allmenus.com/custom-results/-/699018-palo-alto-ca/?filters=filter_delivery,")
URL = ("http://www.allmenus.com/ca/palo-alto/-/&filters=none")
OUTPUT_FILENAME = ("output4.csv")


def get_restaurant_dict():
  web_page = urllib2.urlopen(URL).read()
  soup = BeautifulSoup(web_page)
  restaurant_table = soup.find('div', attrs={'id': 'restaurant_list'})
  restaurant_list = restaurant_table.findAll('li')
  restaurant_dict = ParseRestaurantList(restaurant_list)
  #print restaurant_dict
  for key, value in restaurant_dict.items():
    restaurant_dict[key][0] = "http://www.allmenus.com" + value[0]
  return restaurant_dict  


def main():
  restaurant_dict = get_restaurant_dict()
  #print restaurant_dict
  CreateOutputFile(restaurant_dict)


def CreateOutputFile(restaurant_dict):
  with open(OUTPUT_FILENAME, 'w') as fout:
    for key, value in restaurant_dict.items():
      fout.write(key + ': ' + value + '\n')

def ParseRestaurantList(restaurant_list):
  restaurant_dict = {}
  for restaurant_string in restaurant_list:
    #Some of the characters are a little funky (ie, & -> &amp), some sort of encoding issue
    restaurant_string = unicode(restaurant_string)
    restaurant_string = unicodedata.normalize('NFKD',restaurant_string).encode('ascii', 'ignore')
    #print restaurant_string
    if(restaurant_string.find("<a href") != -1 and restaurant_string.find("Order online") == -1):
      #Get the AllMenus Restaurant URL (for scraping menu)
      url_start_index = restaurant_string.find("<a href=\"") + len("<a href=\"")
      url_end_index = restaurant_string.find("\">", url_start_index) 
      url = restaurant_string[url_start_index:url_end_index]
      #Get the Restaurant Name
      name_start_index = url_end_index + len("\">")
      name_end_index = restaurant_string.find("</a>", name_start_index)
      restaurant_name = restaurant_string[name_start_index:name_end_index]
      #Get the restaurant address
      address_start_index = restaurant_string.find("restaurant_address\">") + len("restaurant_address\">")
      address_end_index = restaurant_string.find("</p>", address_start_index)
      #print address_start_index
      #print address_end_index
      #raw_input("")
      address = restaurant_string[address_start_index:address_end_index]

      restaurant_dict[restaurant_name] = [url, address]

  return restaurant_dict



if __name__ == "__main__":
    main()
