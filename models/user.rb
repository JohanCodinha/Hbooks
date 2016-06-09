class User < ActiveRecord::Base
	has_many :comments
	has_many :books
	has_secure_password
end