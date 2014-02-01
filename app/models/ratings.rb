class Ratings < ActiveRecord::Base
	belongs_to	:food
	belongs_to	:drink
	belongs_to	:user

	validates :score : numericality: {less_than_or_equal_to: 5}
    validates :score : numericality: {greater_than_or_equal_to: 1}
    validates :comment, :length => { :maximum => 200 }

end
