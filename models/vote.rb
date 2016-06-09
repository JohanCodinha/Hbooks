class Vote < ActiveRecord::Base
	belongs_to :book
	belongs_to :user
end