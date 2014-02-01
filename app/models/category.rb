class Category < ActiveRecord::Base
	has_many	:foods
	has_many	:drinks
	has_many	:restaurants

	validates :category, :length => { :in => 3..20 }

end
