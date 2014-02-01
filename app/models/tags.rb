class Tags < ActiveRecord::Base
	has_and_belongs_to_many	:foods
	has_and_belongs_to_many	:drinks
	has_and_belongs_to_many	:pictures
	has_and_belongs_to_many	:restaurants

	validates :description, :length => { :in => 3..20 }

end
