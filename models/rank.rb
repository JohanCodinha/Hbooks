class Rank < ActiveRecord::Base
	belongs_to :book
	has_one :book
end