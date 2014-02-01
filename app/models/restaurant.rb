class Restaurant < ActiveRecord::Base
	has_many	:foods
	has_many	:drinks
	has_and_belongs_to_many	:tags
	
end