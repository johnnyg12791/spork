import urllib2
from bs4 import BeautifulSoup
import csv

URL = "http://openmenu.com/restaurant/20e422e4-15bb-11e0-b40e-0018512e6b26"

def main():
  web_page = urllib2.urlopen(URL).read()
  soup = BeautifulSoup(web_page)
  menu = soup.find('div', attrs={'id': 'om_menu'})
  #print menu
  item_list = menu.findAll('dl')
  item_dict = ParseMenuList(item_list)
  ConvertToCSV(item_dict)

def ConvertToCSV(item_dict):
  with open('output.csv', 'w') as fout:
    for food, price in item_dict.items():
      fout.write(food + ': ' + price + '\n')


def ParseMenuList(item_list):
  item_dict = {}
  for item in item_list:
    item_string = str(item)
    start_index =  item_string.find("\">") + 2
    end_index = item_string.find("</dt>") 
    item_name = item_string[start_index:end_index]
    #print item_name
    price_start_index = item_string.find("price\">") + 7
    price_end_index = item_string.find("</dd>")
    price = item_string[price_start_index:price_end_index]
    #print price
    item_dict[item_name] = price
  return item_dict

if __name__ == "__main__":
    main()


'''
menuItems = soup.findAll('dt', attrs={'class': 'pepper_'})
for item in menuItems:
  print item
'''
