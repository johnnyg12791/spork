class Food < ActiveRecord::Base
	belongs_to	:restaurant
	has_many	:comments
	has_many	:ratings
	has_and_belongs_to_many	:tags

    validates :dish_name, :length => { :minimum => 1 }

    def self.filter(query)
    	return ["optiooooonsssss", "more options!"]
    end

end
