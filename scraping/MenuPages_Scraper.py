import urllib2
from bs4 import BeautifulSoup
import csv

TEST_URL = ("http://sanfrancisco.menupages.com/restaurants/amicis-east-coast-pizzeria/menu")

def get_menu_from_url(URL):
  web_page = urllib2.urlopen(URL).read()
  soup = BeautifulSoup(web_page)
  menu = soup.find('div', attrs={'id': 'restaurant-menu'})
  if(menu != None):
    item_list = menu.findAll('tr')
    item_dict = ParseMenuList(item_list)
    return item_dict
  return {}


def main():
  item_dict = get_menu_from_url(TEST_URL)
  print item_dict

def ConvertToCSV(item_dict):
  with open('output3.csv', 'w') as fout:
    for food, price in item_dict.items():
      fout.write(food + ': ' + str(price) + '\n')


def ParseMenuList(item_list):
  item_dict = {}
  for item in item_list:
    item_string = str(item)

    name_start_index = item_string.find("<cite>") + len("<cite>")
    name_end_index = item_string.find("</cite>", name_start_index) 
    item_name = item_string[name_start_index:name_end_index]

    price_start_indicies = FindAllSubstring(item_string, "<td>")
    price_end_indicies = FindAllSubstring(item_string, "</td>")

    prices = []
    for i in range(len(price_start_indicies)):
      price = item_string[price_start_indicies[i] + len("<td>")+2 : price_end_indicies[i]]
      #raw_input("")
      if(ContainsDigit(price)):
        price = ''.join([c for c in price if c in '1234567890.'])
        #raw_input("")
        prices.append(price)



    item_dict[item_name] = prices

  print item_dict
  raw_input("")
  return item_dict

def ContainsDigit(s):
    return any(char.isdigit() for char in s)

def FindAllSubstring(string, substr):
  indicies = []
  prevIndex = 0
  while(True):
    index = string.find(substr, prevIndex)
    prevIndex = index + 1
    #print index
    if (index == -1 or index in indicies):
      return indicies
    else:
      indicies.append(index)
  

if __name__ == "__main__":
    main()

