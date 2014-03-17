class Food < ActiveRecord::Base
	belongs_to	:restaurant
  belongs_to :category
	has_many	:ratings, as: :ratable
  has_many :pictures, as: :imageable
	has_and_belongs_to_many	:tags

  validates :dish_name, :length => { :minimum => 1 }

end