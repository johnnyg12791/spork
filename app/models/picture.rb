class Picture < ActiveRecord::Base
	belongs_to :imageable, polymorphic: true
	has_and_belongs_to_many	:tags
end
