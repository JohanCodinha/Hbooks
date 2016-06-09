require 'pry'
require 'active_record'

#uncomment to view SQl command
# ActiveRecord::Base.logger = Logger.new(STDERR)

require './db_config'
require './models/user'
require './models/book'
require './models/comment'
require './models/vote'
require './models/rank'
require './main.rb'

binding.pry