require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'tilt/erubis'
require 'yaml'
require 'bcrypt'

#require_relative '/lib/game'

configure do
  enable :sessions
  set :session_secret, 'super secret'
end

not_found do
  session[:message] = "Alas, that page doesn't exist. Here's a familiar place."
  redirect back
  # this takes me back a page, but I want it to stay on the current page
  # and display the error message. Not sure how to do that.   
end


helpers do

end

before do

end

# --------------------- LOGIC/NON HELPER METHODS -------------------

def validate_settings
  all_names_amount = params[:allplayernames].split.size
  if params[:playeramount].to_i != all_names_amount
    session[:message] = "Please provide #{params[:playeramount]} names."
    redirect back
  end
end

def get_challenges
  if session[:challengetype] == 'physical'
    @challenges = 
end

# --------------------- ROUTES ---------------------------

# Homepage redirects to actual home page
get '/' do
  redirect '/home'
end

# View home page
get '/home' do
  erb :home
end

# View instructions
get '/instructions' do
  erb :instructions
end

# View signin page
get '/signin' do
  erb :signin
end

# Submit signin credentials
post '/signin' do

end

# View signup page
get '/signup' do
  erb :signup
end

# Submit signup credentials
post '/signup' do

end

# Play a game
get '/game/play' do
  get_challenges
  erb :play
end

# View game settings
get '/game/settings' do
  session[:playerturns] = 1
  session[:roundamount] = 5
  session[:currentround] = 1
  session[:playeramount] = 2
  session[:challengetype] = 'all'
  session[:playernames] = ['Callie', 'David']

  # setting that to false so that people can't bypass the settings. The app
  # will return them to the settings page unless they've confirmed them
  # which will toggle this value to true
  session[:settingscompleted] = false
  erb :settings
end

# Submit and validate game settings
post '/game/settings' do
  validate_settings
  redirect '/game/play'
end
