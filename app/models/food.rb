class Food < ActiveRecord::Base
	belongs_to	:restaurant
  belongs_to :category
	has_many	:ratings, as: :ratable
  has_many :pictures, as: :imageable
	has_and_belongs_to_many	:tags

  validates :dish_name, :length => { :minimum => 1 }

    def self.filter(query)
    	return ["optiooooonsssss", "more options!"]
    end

    def get_avg_rating
      result = 0
      if self.ratings.length > 0
        for rating in self.ratings do
          result += rating.score
        end
        result = result/self.ratings.length
      end
      return result
    end
end
