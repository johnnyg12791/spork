from AllMenu_GetRestaurants import *
from AllMenu_Scraper import *
import time

'''
This is a seed.rb test

I want an array of restuarant-info arrays:
[['coho', '7am-10pm' 'come eat], ['treehouse', '', ''], ['tap', 'burgers', '']]

And an array of arrays of menu item-arrays at coho (yup, 3 levels???)
[
[['panini', '4.99', 'bread and lettuce'], ['salad', '5.99', 'lettuce']], 
[['cheeseburger', '7.99'], ['steak burrito', '4.99']], 
[['chicken', '4.99'], ['lamb burger', '13.50', 'healthy']]
]

'''
#Restaurant.create(name: 'CoHo', latitude: 37.4238362, longitude: -122.170774, description: "The Coffee House, yum", hours: "7am - Midnight")





def main():
  format_arrays()


def format_arrays():
  array_of_restaurant_arrays = []
  triple_array_of_items = []
  restaurant_dict = get_restaurant_dict()
  #start with 2
  restaurant_id = 2
  for name, url_address in restaurant_dict.items():
    restaurant_array = []
    #name, lat, long, desc, hours
    restaurant_array.append(name)    
    restaurant_array.append('0.0')#latitude
    restaurant_array.append('0.0')#longitude #Would we rather(also) have the actual address? probably...
    restaurant_array.append(url_address[1])#Address
    restaurant_array.append('Good Food')#description #allmenus.com does not seem to have that?
    restaurant_array.append('1pm-10pm')#hours (gettable in string format)
    #Print
    print restaurant_array
    raw_input("")

    #Now I want to go get the URL and access the menu items
    menu_items = get_menu_from_url(url_address[0])
    time.sleep(2.0)
    #print menu_items
    #raw_input("")
    items_in_restaurant = []
    for item, price_description in menu_items.items():
      item_array = []
      #dish_name, restaurant_id, price, description, size, calories, nutrition, presentation
      item_array.append(item)
      item_array.append(restaurant_id)
      item_array.append(price_description[0])
      item_array.append(price_description[1])
      item_array.append('')#size
      item_array.append('')#calories
      item_array.append('')#nutrition
      item_array.append('')#presentation


      items_in_restaurant.append(item_array)
    restaurant_id += 1
    triple_array_of_items.append(items_in_restaurant)


    #print menu_items
    #raw_input("")


    array_of_restaurant_arrays.append(restaurant_array)    
    #print array_of_restaurant_arrays
    #raw_input("")

  print array_of_restaurant_arrays
  print triple_array_of_items
#def ReadResta

if __name__ == "__main__":
  main()

