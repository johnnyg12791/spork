class Food < ActiveRecord::Base
	belongs_to	:restaurant
  belongs_to :category
	has_many	:ratings, as: :ratable
  has_many :pictures, as: :imageable
	has_and_belongs_to_many	:tags

  validates :dish_name, :length => { :minimum => 1 }

  before_save :update_average

  def update_average
    self.num_ratings = self.ratings.count
    self.rating = (self.ratings.inject(0){|sum, x| sum + x.score})/self.ratings.count.to_f
    return true
  end
end