class Ratings < ActiveRecord::Base
	belongs_to	:food
	belongs_to	:drink
	belongs_to	:user
end
