# Kyle N. Smith, in partnership with Seth Lieberman
require 'sinatra' 
require 'sinatra/activerecord'

configure(:development){set :database, "sqlite3:blog.sqlite3"}
require './models'
require 'bundler/setup'     
require 'sinatra/flash'
enable :sessions
set :sessions, true

	#this is defining the current user for the session
def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end


class Users
	attr_accessor :email, :name, :city, :password, :created_at
	
	def initialize(email, name, city, password, created_at)
      @email=email
      @name=name
      @city=city
      @password=password
      @created_at=created_at
   end
end	



# class Posts
# 	attr_accessor :content, :posted_at, :user_id
# end	

# class Profiles
# 	attr_accessor :user_id, :name, :bio, :city, :picture, :bg_color, :text_color
# end	

get '/' do
	erb :home, :layout => nil
end

	
	#when the user signs in this is asking for the username and password to match 
	#otherwise it takes them to the registration page
post '/home' do
	@user = User.where(email: params[:email]).first
	# @user.profile = @profile
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id 
		redirect '/userpage' 

	else    
		redirect '/registration'

	end
end


# Route displays the settings view.
get '/settings' do

	erb :settings
end

# Route displays the userpage view while setting variables to be called in the route
get '/userpage' do
	@post = Post.all
	@user = User.all
	erb :userpage
end

# This page will pull the user_id and load it to populate a new profile.  The route also allows clients to be able to directly load a page based on the URL user ID that is included in the page for easy referencing.
get '/user_:user_id' do
	@post = Post.where(user_id: params[:user_id])
	@user = User.find_by_id(params[:user_id])
	@background = @user.profile.bg_color
	@usertext = @user.profile.text_color
	erb :view_user
end

# This will save the posts to the database under the user id for the person that created it
post '/userpage' do
@post = Post.create(content: params[:content], user_id: session[:user_id])
		redirect '/userpage'
end

# Route for the registration view.  Turned off the layout so that clients wouldn't be confused with session user features being shown as if they are available.  Would need to build an additional view in a more complete build.
get '/registration' do
	erb :registration, :layout => nil
end

# Captures values sent via the post method to the settings route then redirects to the userpage.
post '/settings' do
		#this creates the profile in database
		@profile = Profile.create(bio: params[:bio], picture: params[:picture], bg_color: params[:bg_color], text_color: params[:text_color], user_id: session[:user_id])
		current_user.profile.update_attributes(bio: params[:bio], picture: params[:picture], bg_color: params[:bg_color], text_color: params[:text_color], user_id: session[:user_id])
		redirect '/userpage'
end

	#this is the registration page where they enter their details
	#this should be passed through to the current_user
post '/registration' do

	@user = User.create(email: params[:email], password: params[:password], name: params[:name], city: params[:city])
	@user.profile = Profile.create(name: params[:name], city: params[:city])
		erb :home
	redirect '/'
end	

# Captures values sent via the update_profile route and then redirects client to their userpage.
post '/update_profile' do
	current_user.profile.update_attributes(bio: params[:bio])
	erb :userpage	
end


post '/sign-out' do
	session[:user_id] = nil
	redirect '/'
end

# Link to allow for signout function in the nav bar rather than a post function.
get '/sign-out' do
	session[:user_id] = nil
	redirect '/'
	# erb :home
		
end

# creates a unique route via the selected iteration's ID and runs a function to destroy that post before redirecting the session user to their userpage.
get '/delete_:id' do
	Post.destroy(params[:id])
	 redirect '/userpage'
end

# creates a unique route using the user_id and runs a function to add the selected user to the follow join table so that the selected user can be displayed on the following list for the current session user.  Then redirects to the current session userpage.
get '/follow_:user_id' do
	@user = User.find_by_id(params[:user_id])
	@posts = @user.posts 
	current_user.user_friends.push(@user)
	redirect '/userpage'
end

# Route calls a function to destroy the record on the join table if both values are found in the table.  This removes a user from a following list.
get '/d_follow:id' do
	Follow.where(user_friend_id: params[:id], user_id: current_user.id).first.destroy
	 redirect '/userpage'	 
end




