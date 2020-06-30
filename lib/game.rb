class Player
  attr_accessor :name, :score, :turn
  
  def initialize(name)
    @name = name
    @turn = 1
    # ask for the name of this player
    @score = 0
  end
  
  def get_challenge(type)
    @challenge = Challenge.new(type) 
  end

  def approve_performance
    @score += 1
  end

  def play
    puts "Here's their challenge:"
    puts Challenge.new.text
    puts "We wait seven seconds..."
    puts "Did they complete the challenge?"
    answer = nil
    loop do
      answer = gets.chomp
      break if %w(yes no).include?(answer)
      puts "Please say yes or no. Did they complete the challenge?"
    end
    approve_performance if answer == 'yes'
    puts "Noted. On to the next!"
  end

  def next_turn
    self.turn += 1
  end
end

class Challenge
  attr_reader :text

  def initialize(type='all')
    @success = 'undetermined'

    if type == 'all'
      @text = 'This is either a physical or verbal challenge'
    elsif type == 'physical'
      @text = 'This is a physical challenge'
    elsif type == 'verbal'
      @text = 'This is a verbal challenge'
    else
      # warn them that this is not a possible option
      # Could let them try again or let it default to all
    end
  end

end

class Game
  NUMBER_WORDS = %w(first second third fourth fifth sixth seventh eighth)

  attr_accessor :player_turns_amount, :round_amount, :challenge_type, :current_player, :current_round

  def initialize(player_turns_amount = 1, round_amount = 2, challenge_type = 'all')
    @player_turns_amount = player_turns_amount
    @round_amount = round_amount
    @challenge_type = challenge_type
    @current_player = 0
    @current_round = 1
    @all_players = []

    # initialize the amount of players given
    # These should be player objects
  end

  def prompt_player_amount
    answer = nil
    loop do
      puts "How many players will be playing this game? Choose any number between 2 and 8."
      answer = gets.chomp.to_i
      break if answer >= 2 && answer < 8
      puts "Sorry, we need a number between 2 and 8."
    end
    @player_amount = answer
  end

  def prompt_turns_amount
    answer = nil
    loop do
      puts "How many turns would you like everyone to have? Right now they have #{@player_turns_amount}. Is that okay? (answer 'yes' or 'no')"
      answer = gets.chomp.downcase
      break if %w(yes no).include?(answer)
      puts "Say 'yes' or 'no', please."
    end

    loop do
      if answer == 'yes'
        puts "Alright, great!"
        break
      else
        puts "Okay, how many turns would you like each user to have per round? You can choose between 1 and 5."
        answer = gets.chomp.to_i
        break if answer >= 1 && answer < 6
        puts "Can only choose between 1 and 5, my friend."
      end
    end
    @player_turns_amount = answer
    @player_turns_amount = 1 if @player_turns_amount == 'yes'
    puts "Okay, each player will get #{@player_turns_amount} turns per round."

  end

  def create_all_players
    puts "Please provide a name for each of the players:"
    @all_players = []
    @player_amount.times do |idx|
      name = nil
      loop do
        puts "What is the name of the #{NUMBER_WORDS[idx]} player?"
        name = gets.chomp.strip.capitalize
        break unless name.empty?
        puts "We realllly need a name."
      end
      @all_players << Player.new(name)
    end

    puts "Thanks! All the names of the players are:"
    @all_players.each {|player| puts player.name }
  end

  def player_full_turn
    puts "Is #{@all_players[@current_player].name} ready?"
    answer = gets.chomp
    puts "Here we go!"

    @player_turns_amount.times do |iteration|
      @all_players[@current_player].play
    end
    
    increment_round
  end

  def turn_over?(player)
    player.turn == @player_turns_amount
  end

  def increment_round
    @current_round += 1 if @current_player == @all_players.size - 1
  end

  def choose_next_player
    if @current_player == @all_players.size - 1
      announce_new_round
      @current_player = 0
    else
      @current_player += 1
    end
  end

  def announce_new_round
    puts "That's the end of round #{@current_round - 1}!"
    puts "And now....time for round #{@current_round}!"
  end

  def game_over?
    @current_round > @round_amount
  end

  def determine_winner
    win_amount = @all_players.max { |player| player.score }.score
    @winner = @all_players.select {|player| player.score == win_amount}
  end


  def display_results
    puts "And that's a wrap!"
    puts "Here was our lineup..."
    @all_players.each do |player|
      puts "#{player.name}'s score was #{player.score}"
    end
    
    display_grand_winner    
  end

  def display_grand_winner
    determine_winner
    
    if @winner.size == 1
      player = @winner[0]
      puts "And the grand winner is...#{player.name} with #{player.score} points!!"
    elsif @winner.size == 2
      puts "There was a tie! Both #{@winner[0].name} and #{@winner[1].name} won with #{@winner[0].score} points!"
    else
      puts "distraction"
      puts "There was a huge tie! #{@winner[0..-2].join(', ')}, and #{@winner[-1]} won with #{@winner[0].score} points!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?"
      answer = gets.chomp.downcase
      break if %w(yes no).include?(answer)
      puts "Please say yes or no."
    end
    answer == 'yes'
  end

  def display_welcome
    puts "Welcome to the Seven Second Game!"
  end

  def display_goodbye
    puts "Thanks for playing! Bye!"
  end

  def play
    display_welcome
    loop do
      prompt_player_amount
      prompt_turns_amount
      create_all_players

      loop do
        player_full_turn
        break if game_over?
        choose_next_player
      end

      display_results
      break unless play_again?
    end

    display_goodbye
  end
end









































#   def select_next_player
#     if @current_player.nil?
#       current_player = session[:playernames][0]
#     else
#       next_index = session[:playernames].index(@current_player) + 1
#       if session[:playernames][next_index].nil?
#         round_ends
#       else
#         @current_player = session[:playernames][next_index]
#       end
#     end
#   end
# 
#   def display_are_you_ready
#   end
# 
#   def display_challenge
#     @challenge = "Use someone's foot as a telephone"
#   end
# 
#   def round_ends
#     return game_ends if session[:roundamount] == session[:currentround]
# 
#     session[:display] = "Round #{session[:currentround]} is done!"
#   end
# 

