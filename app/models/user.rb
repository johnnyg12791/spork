class User < ActiveRecord::Base	
	has_many :ratings
	has_many :pictures
	has_one :admin

  validates :first_name, :length => { :minimum => 1 }
  validates :last_name, :length => { :minimum => 1 }
  validates :rating_score, :numericality => {greater_than_or_equal_to: 0}
  validates :rating_score, :numericality => {less_than_or_equal_to: 5}
end
