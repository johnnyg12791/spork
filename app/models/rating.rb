class Rating < ActiveRecord::Base
  belongs_to :ratable, polymorphic: true
  belongs_to :user

	validates :score, :numericality => {less_than_or_equal_to: 5}
  validates :score, :numericality => {greater_than_or_equal_to: 1}
  validates :comment, :length => { :maximum => 200 }

  after_create :set_average

  def set_average
    self.ratable.save!
    return true
  end

end
