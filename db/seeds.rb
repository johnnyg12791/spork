# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

seed_file = File.join(Rails.root, 'db', 'seeds.yml')
config = YAML::load_file(seed_file)
r = Restaurant.create(config["restaurants"])
r.first.foods = Food.create(config["foods"])
r.first.pictures = Picture.create(config["pictures"])

#Formatted file located in seeds.yml