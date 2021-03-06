import urllib2
from bs4 import BeautifulSoup
import csv

URL = "http://www.allmenus.com/ca/san-jose/55759-california-pizza-kitchen/menu/"


def get_menu_from_url(URL):
  web_page = urllib2.urlopen(URL).read()
  soup = BeautifulSoup(web_page)
  menu = soup.find('div', attrs={'id': 'menu'})
  if(menu != None):
    item_list = menu.findAll('li')
    item_dict = ParseMenuList(item_list)
    return item_dict
  return {}

def main():
  item_dict = get_menu_from_url(URL)
  ConvertToCSV(item_dict)

def ConvertToCSV(item_dict):
  with open('output2.csv', 'w') as fout:
    for food, price in item_dict.items():
      fout.write(food + ': ' + price + '\n')


def ParseMenuList(item_list):
  item_dict = {}
  for item in item_list:
    item_string = str(item)
    name_start_index =  item_string.find("<span class=\"name\">") + len("<span class=\"name\">")
    name_end_index = item_string.find("</span>", name_start_index) 
    item_name = item_string[name_start_index:name_end_index]

    price_start_index = item_string.find("\"price\">") + len("\"price\">")
    price_end_index = item_string.find("</span>", price_start_index)
    price = ''

    if(price_start_index != (-1+len("\"price\">"))):
      price = item_string[price_start_index:price_end_index]

    #get the item description as well
    description_start_index = item_string.find("\"description\">") + len("\"description\">")
    description_end_index = item_string.find("</p>")

    description = ''
    if(description_start_index != (-1+len("\"description\">"))):
      description = item_string[description_start_index:description_end_index]
    item_dict[item_name] = [price, description]


    #print item_name
    #print price
    #print item_string


  return item_dict
  

if __name__ == "__main__":
    main()

