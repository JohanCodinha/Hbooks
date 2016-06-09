require 'active_record'

options = {
	adapter: 'postgresql',
	database: 'hbooks',

}

ActiveRecord::Base.establish_connection(options)