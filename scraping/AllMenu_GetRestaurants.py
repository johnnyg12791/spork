#AllMenu_GetRestaurants
#We are going to compile website urls here

import urllib2
from bs4 import BeautifulSoup
import csv

URL = ("http://www.allmenus.com/custom-results/-/699018-palo-alto-ca/?filters=filter_delivery,")
OUTPUT_FILENAME = ("output4.csv")


def main():
  web_page = urllib2.urlopen(URL).read()
  soup = BeautifulSoup(web_page)
  restaurant_table = soup.find('div', attrs={'id': 'restaurant_list'})
  restaurant_list = restaurant_table.findAll('p')
  restaurant_dict = ParseRestaurantList(restaurant_list)
  #print restaurant_dict
  for key, value in restaurant_dict.items():
    restaurant_dict[key] = "http://www.allmenus.com" + value
  #print restaurant_dict
  CreateOutputFile(restaurant_dict)


def CreateOutputFile(restaurant_dict):
  with open(OUTPUT_FILENAME, 'w') as fout:
    for key, value in restaurant_dict.items():
      fout.write(key + ': ' + value + '\n')

def ParseRestaurantList(restaurant_list):
  restaurant_dict = {}
  for restaurant_string in restaurant_list:
    restaurant_string = str(restaurant_string)
    #print restaurant_string
    #raw_input("")
    if(restaurant_string.find("<a href") != -1 and restaurant_string.find("Order online") == -1):
      #print restaurant_string
      #print restaurant_string.find("href")
      #raw_input("")

      url_start_index = restaurant_string.find("<a href=\"") + len("<a href=\"")
      url_end_index = restaurant_string.find("\">", url_start_index) 
      url = restaurant_string[url_start_index:url_end_index]
      name_start_index = url_end_index + len("\">")
      name_end_index = restaurant_string.find("</a>")
      restaurant_name = restaurant_string[name_start_index:name_end_index]
      restaurant_dict[restaurant_name] = url

  return restaurant_dict



if __name__ == "__main__":
    main()
