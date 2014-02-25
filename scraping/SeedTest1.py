from AllMenu_GetRestaurants import *
from AllMenu_Scraper import *
import time

START_RESTAURANT_ID = 2

def main():
  (restaurants, menu_items) = format_arrays()
  output_restaurant_yml(restaurants, 'restaurant_yml.txt')
  output_foods_yml(menu_items, 'food_yml.txt')


def output_restaurant_yml(restaurants, file):
  with open(file, 'w') as fout:
    for restaurant in restaurants:
      fout.write('  -' + '\n')
      fout.write('    name: ' + '\"' + restaurant[0] + '\"' + '\n')
      fout.write('    latitude: ' + restaurant[1] + '\n')
      fout.write('    longitude: ' + restaurant[2] + '\n')
      fout.write('    address: '+ '\''  + restaurant[3] + '\'' + '\n')
      fout.write('    description: '+ '\''  + restaurant[4] + '\'' + '\n')
      fout.write('    hours: '+ '\''  + restaurant[5] + '\'' + '\n')



def output_foods_yml(foods, file):
  with open(file, 'w') as fout:
    for restaurant_menu in foods:
      for menu_item in restaurant_menu:
        fout.write('  -' + '\n')
        fout.write('    dish_name: '+ '\"'  + menu_item[0] + '\"' + '\n')
        fout.write('    restaurant_id: ' + str(menu_item[1]) + '\n')
        fout.write('    price: '+ '\''  + menu_item[2] + '\'' + '\n')
        fout.write('    description: '+ '\"'  + menu_item[3] + '\"' + '\n')
        #fout.write('    size: ' + menu_item[0] + '\n')
        #fout.write('    dish_name: ' + menu_item[0] + '\n')







def format_arrays():
  array_of_restaurant_arrays = []
  triple_array_of_items = []
  restaurant_dict = get_restaurant_dict()
  print restaurant_dict
  #start with 2
  restaurant_id = START_RESTAURANT_ID
  for name, url_address in restaurant_dict.items():
    restaurant_array = []
    #name, lat, long, desc, hours
    restaurant_array.append(name)    
    restaurant_array.append('0.0')#latitude
    restaurant_array.append('0.0')#longitude #Would we rather(also) have the actual address? probably...
    restaurant_array.append(url_address[1])#Address
    restaurant_array.append('Good Food')#description #allmenus.com does not seem to have that?
    restaurant_array.append('1pm-10pm')#hours (gettable in string format)

    #Now I want to go get the URL and access the menu items
    menu_items = get_menu_from_url(url_address[0])
    time.sleep(3.0)
    #print menu_items
    print restaurant_array[0] #just to see progress
    #raw_input("")
    items_in_restaurant = []
    for item, price_description in menu_items.items():
      item_array = []
      sanitized_item = item.replace("\"", "\'")
      description = price_description[1].replace("\"", "\'")
      #dish_name, restaurant_id, price, description, size, calories, nutrition, presentation
      item_array.append(sanitized_item)
      item_array.append(restaurant_id)
      item_array.append(price_description[0])
      item_array.append(description)
      item_array.append('')#size
      item_array.append('')#calories
      item_array.append('')#nutrition
      item_array.append('')#presentation


      items_in_restaurant.append(item_array)
    restaurant_id += 1
    triple_array_of_items.append(items_in_restaurant)
    array_of_restaurant_arrays.append(restaurant_array)   

  #print array_of_restaurant_arrays
  #print triple_array_of_items
  return (array_of_restaurant_arrays, triple_array_of_items)


if __name__ == "__main__":
  main()

