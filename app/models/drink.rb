class Drink < ActiveRecord::Base
	belongs_to	:restaurant
	has_many	:comments
	has_many	:ratings, as: :ratable
  has_many :pictures, as: :imageable
	has_and_belongs_to_many	:tags

	validates :name, :length => { :minimum => 1 }

    def self.filter(query)
    	return ["optiooooonsssss", "more options!"]
    end

end
