class Drink < ActiveRecord::Base
	belongs_to	:restaurant
	has_many	:comments
	has_many	:ratings
	has_and_belongs_to_many	:tags

end
