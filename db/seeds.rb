# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Restaurant.create(name: 'CoHo', latitude: 37.4238362, longitude: -122.170774, description: "The Coffee House, yum", hours: "7am - Midnight")
Food.create(dish_name: 'Panini', restaurant_id: 1, price: '4.95', description: 'Hot and Fresh', size: 5, calories: 500, nutrition: 'Good', presentation: 4)
Food.create(dish_name: 'Sandwhich', restaurant_id: 1, price: '5.50', description: 'Meat optional', size: 4, calories: 400, nutrition: 'Bad', presentation: 3)
Food.create(dish_name: 'Salad', restaurant_id: 1, price: '6.95', description: 'Lots of green', size: 3, calories: 300, nutrition: 'Healthy', presentation: 4)
Food.create(dish_name: 'John Food', restaurant_id: 1, price: '4.00', description: 'stuff')
#Eventually I want to create a formatted file with lots of Restaurants and Foods/Drinks


