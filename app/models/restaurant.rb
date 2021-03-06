class Restaurant < ActiveRecord::Base
  has_many  :foods
  has_many  :drinks
  has_many  :pictures, as: :imageable
  has_and_belongs_to_many :tags
  belongs_to :category
  has_one :hour
  validates :description, :length => { :maximum => 200 }
  has_one :admin

end
