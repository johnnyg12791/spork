# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

seed_file = File.join(Rails.root, 'db', 'final_seeds_5.yml')
config = YAML::load_file(seed_file)
Restaurant.create(config["restaurants"])
Food.create(config["foods"])
Picture.create(config["pictures"])
User.create(config["users"])
Rating.create(config["ratings"])


#Formatted file located in seeds.yml