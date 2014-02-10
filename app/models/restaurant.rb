class Restaurant < ActiveRecord::Base
	has_many	:foods
	has_many	:drinks
    has_many :pictures
	has_and_belongs_to_many	:tags

	validates :description, :length => { :maximum => 200 }


end
