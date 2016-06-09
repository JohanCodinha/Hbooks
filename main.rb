#gems
require 'sinatra'
require 'sinatra/reloader'
require 'vacuum'

#databe config and models
require './db_config'
require './models/user'
require './models/book'
require './models/comment'
require './models/vote'
require './models/rank'

enable :sessions

def current_user
	User.find_by(id: session[:user_id])
end

def logged_in?
	!!current_user
end

def display_time(stamp)
	now = Time.new.to_i
	elapsed = now - stamp

	if (elapsed < 60)
		return "#{now - stamp} sec ago"
	elsif (elapsed > 60 && elapsed < 3600)
		minutes = elapsed/60
		return "#{minutes} #{minutes > 1 ? 'minutes': 'minute'} ago"
	elsif (elapsed > 3600 && elapsed < 86400)
		hours = elapsed/3600
		return "#{hours} #{hours > 1 ? 'hours': 'hour'} ago"
	else
		days = elapsed/86400
		return "#{days} #{days > 1 ? 'days' : 'day' } ago"
	end
end

def display_votes(book_id)
	if session[:user_id] != nil
		if Vote.where(user_id: current_user.id, book_id: book_id) == []
			return "<a href='/vote/#{book_id}'>▲</a>"
		end
	else
		return "<a href='/vote/#{book_id}'>▲</a>"
	end
end

def rank
	# to rank we take the votes and divided by the time in hours
	# store the result in the ranks table
	Book.all.each {|book|
		votes = book.votes
		hours = ((Time.now.to_i - book.timestamp)/3600)
		rank = (votes/(hours+2))+(votes % (hours+2))
		puts "#{book.title} is ranked #{rank}"
		puts "#votes : #{votes} | hours : #{hours}"
		book_rank = Rank.find_by(book_id: book.id)

		if book_rank == nil
			Rank.create(book_id: book.id, rank: rank)
		else 
			book_rank.rank = rank
		end
	}
end 

get '/submit' do
	if session[:user_id] != nil
  erb :submit
	else 
		erb :login
	end
end

post '/submit' do

	if params[:isbn] == ''
		erb :searchbook

	else
		Book.create(title: params['title'],
								isbn: params['isbn'],
								link: params['link'],
								user_id: session[:user_id],
								timestamp: Time.new.to_i,
								votes: 0)
	end
	redirect to '/'
end

get '/' do

	@books = Book.all
	@users = User.all
	@vote = Vote.all
	@rank = Rank.order(:rank)
	rank
	erb :frontpage
end

#create a session
get '/session/new' do
	erb :login
end

get '/signin' do
	erb :signin
end

post '/signin' do
	User.create(name: params[:name], email: params[:email], password: params[:password])
	redirect to '/'
end
#deleting a session
delete '/session' do 
	session[:user_id] = nil
	redirect to '/'
end 

post '/session' do 
	user = User.find_by(email: params[:email])
	if user && user.authenticate(params[:password])
	#we'r in ! create a new session
	session[:user_id] = user.id
	# redirect
	redirect to '/'
	else 
	# stay at login form
	erb :login
	end 
end

get '/book/:id' do
	@user = User
	@book = Book.find_by(id: params[:id])
	@bookcom = @book.comment.all
	# raise User.find_by(id: Book.last.comment[1].user_id).name
	erb :book
end

post '/book/comment' do
	if session[:user_id] != nil
		Comment.create(book_id: params[:book_id], body: params[:body], user_id: current_user.id, timestamp: Time.new.to_i)
		redirect to "/book/#{params[:book_id]}"
	else 
		erb :login
	end
end

get '/vote/:book_id' do 
	if session[:user_id] != nil
		if Vote.where(user_id: current_user.id, book_id: params[:book_id]) != [] # book_id: params[:book_id]
			redirect to '/'
		else
			Vote.create(user_id: current_user.id, book_id: params[:book_id])
			book = Book.find_by(id: params[:book_id])
			book.votes += 1
			book.save
		redirect to '/'
		end
	else
		erb :login
	end
end

