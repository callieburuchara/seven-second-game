require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'tilt/erubis'
require 'yaml'
require 'bcrypt'

require_relative 'lib/game'

configure do
  enable :sessions
  set :session_secret, 'super secret'
end

not_found do
  session[:error] = "Alas, that page doesn't exist. Here's a familiar place."
  redirect back
  # this takes me back a page, but I want it to stay on the current page
  # and display the error message. Not sure how to do that.   
end


helpers do

end

before do
  pass unless request.path.include?('/play')
  @game = session[:game]
  @current_round = @game.current_round
  @player_amount = session[:playeramount]
  @challenge_type = @game.challenge_type
  @all_names = session[:allplayernames]
end

# --------------------- LOGIC/NON HELPER METHODS -------------------

def validate_settings
  all_names_amount = params[:allplayernames].split.size
  session[:allplayernames] = params[:allplayernames]
  session[:playeramount] = params[:playeramount]
  if params[:playeramount].to_i != all_names_amount
    session[:error] = "Please provide #{params[:playeramount]} names."
    redirect back
  end
end

def initialize_challenges
  challenges = YAML.load_file('data/challenges.yml')
  if session[:challengetype] == 'physical'
    @challenges = challenges['physical'].shuffle
  elsif session[:challengetype] == 'verbal'
    @challenges = challenges['verbal'].shuffle
  else
    @challenges = (challenges['physical'] + challenges['verbal']).shuffle
  end
end

def initialize_players
  number = session[:playeramount].to_i
  @all_players = []
  
  number.times do |idx|
    @all_players << Player.new(session[:allplayernames][idx])
  end
end

def initialize_game
  initialize_challenges
  initialize_players
  @game = Game.new(session[:playerturns], session[:roundamount], session[:challengetype])
  session[:game] = @game
  @each_turn_amount = @game.player_turns_amount
  @current_round = @game.current_round
  @player_amount = session[:playeramount]
  @challenge_type = @game.challenge_type
  @all_names = session[:allplayernames]
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
  
  erb :play
end


# View game settings
get '/game/settings' do
  params[:allplayernames] = params[:allplayernames].inspect
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

# Submit and validate game settings and initialize all game details before redirecting to game page
post '/game/settings' do
  validate_settings
  initialize_game
  redirect '/game/play'
end
