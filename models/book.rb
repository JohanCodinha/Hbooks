class Book < ActiveRecord::Base
	has_many :comment
	has_one :rank
	belongs_to :user
end