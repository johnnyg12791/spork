class Pictures < ActiveRecord::Base
	belongs_to	:drink
	belongs_to	:food
	belongs_to	:restaurant
	has_and_belongs_to_many	:tags

end
