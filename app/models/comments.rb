class Comments < ActiveRecord::Base
	belongs_to	:foods
	belongs_to	:drinks
	belongs_to	:restaurants
	belongs_to	:pictures
end
