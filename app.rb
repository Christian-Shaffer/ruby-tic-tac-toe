class GameBoard
  attr_accessor :spots, :turn_count, :game_active

  def initialize
    @spots = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @turn_count = 1
    @game_active = true
    start_message
  end

  def start_message
    puts 'Welcome to Tic Tac Toe!'
    show_board
    puts 'Player 1 is X and player 2 is O.'
    puts 'Player 1 goes first.'
  end

  def show_board
    puts " #{@spots[0]} | #{@spots[1]} | #{@spots[2]} \n-----------\n #{@spots[3]} | #{@spots[4]} | #{@spots[5]} \n-----------\n #{@spots[6]} | #{@spots[7]} | #{@spots[8]} "
  end

  def valid_move?(chosen_spot)
    if @spots[chosen_spot.to_i - 1] != 'X' && @spots[chosen_spot.to_i - 1] != 'O' && (chosen_spot.to_i >= 1 && chosen_spot.to_i <= 9)
      true
    else
      false
    end
  end

  def whos_turn?
    if (@turn_count % 2).even? == false
      'player1'
    else
      'player2'
    end
  end

  def draw?
    if @spots.all? { |spot| spot == 'X' || spot == 'O' } && @game_active
      @game_active = false
      true
    else
      false
    end
  end

  def check_for_winner
    winning_combinations = [
      [0, 1, 2], # Top row
      [3, 4, 5], # Middle row
      [6, 7, 8], # Bottom row
      [0, 3, 6], # Left column
      [1, 4, 7], # Middle column
      [2, 5, 8], # Right column
      [0, 4, 8], # Left-to-right diagonal
      [2, 4, 6]  # Right-to-left diagonal
    ]

    winning_combinations.each do |combination|
      if @spots[combination[0]] == 'X' && @spots[combination[1]] == 'X' && @spots[combination[2]] == 'X'
        @game_active = false
        return 'X wins!'
      elsif @spots[combination[0]] == 'O' && @spots[combination[1]] == 'O' && @spots[combination[2]] == 'O'
        @game_active = false
        return 'O wins!'
      end
    end

    if draw?
      @game_active = false
      return "It's a draw!"
    end

    nil
  end

  def turn_over
    @turn_count += 1
  end
end

class Player
  attr_accessor :game_board, :letter

  def initialize(game_board, letter)
    @game_board = game_board
    @letter = letter
  end

  def make_move(chosen_spot)
    if @game_board.valid_move?(chosen_spot)
      @game_board.spots[chosen_spot.to_i - 1] = @letter
      @game_board.turn_over
      @game_board.show_board
    else
      puts 'Spot taken or invalid entry'
    end
  end
end

class Game
  attr_accessor :game_board, :player1, :player2, :game_over

  def initialize(game_board, player1, player2)
    @game_board = game_board
    @player1 = player1
    @player2 = player2
    @game_over = false
  end

  def start_game
    while @game_board.game_active
      puts "#{current_player.letter}'s turn. Choose a spot:"
      chosen_spot = gets.chomp
      current_player.make_move(chosen_spot)
      result = @game_board.check_for_winner
      puts result if result
    end
  end

  def current_player
    @game_board.whos_turn? == 'player1' ? @player1 : @player2
  end
end

game_board = GameBoard.new
player1 = Player.new(game_board, 'X')
player2 = Player.new(game_board, 'O')
tic_tac_toe = Game.new(game_board, player1, player2)

tic_tac_toe.start_game
