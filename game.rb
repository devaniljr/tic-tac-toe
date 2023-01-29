require_relative 'game_input'

class Game
  include GameInput

  def initialize
    @board = (0..8).to_a
    @player1 = "✖" # the player 1 marker
    @player2 = "●" # the player 2 / computer marker
    @type = GameInput::get_type
    @difficulty = GameInput::get_difficulty unless @type == 'p1_vs_p2'
  end

  def start_game
    puts "\nLET'S PLAY"
    print_board

    if @type == 'p1_vs_com'
      play_player_vs_computer
    elsif @type == 'p1_vs_p2'
      play_player1_vs_player2
    elsif @type == 'com_vs_com'
      play_computer_vs_computer
    end

    if game_is_over(@board)
        puts "Game over"
    elsif tie(@board)
        puts "It was a tie!"
    end
  end

  def get_human_spot(player)
    spot = nil

    until spot
      spot = GameInput::get_number_spot
      if @board[spot] != "✖" && @board[spot] != "●"
        @board[spot] = player
      else
        puts "Spot already taken"
        spot = nil
      end
    end
  end

  def eval_board(player)
    spot = nil

    until spot
      if @board[4] == "4" && @difficulty == 'hard'
        spot = 4
        @board[spot] = player
      else
        spot = get_best_move(@board, player)
        if @board[spot] != "✖" && @board[spot] != "●"
          @board[spot] = player
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(board, next_player)
    available_spaces = []
    best_move = nil

    board.each do |s|
      if s != "✖" && s != "●"
        available_spaces << s
      end
    end

    available_spaces.each do |as|      
      board[as.to_i] = @player1
      if game_is_over(board)
        best_move = as.to_i
        board[as.to_i] = as
      else
        board[as.to_i] = @player2
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
        else
          board[as.to_i] = as
        end
      end
    end

    if best_move
      if @difficulty == 'hard'
        return best_move
      elsif @difficulty == 'medium'
        return best_move if rand() < 0.5
        return available_spaces.sample.to_i
      else
        return available_spaces.sample.to_i
      end
    else
      return available_spaces.sample.to_i
    end
  end

  def game_is_over(b)
    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  def tie(b)
    b.all? { |s| s == "✖" || s == "●" }
  end

private

  def play_player_vs_computer
    puts "Enter [0-8]:"
    until game_is_over(@board) || tie(@board)
      get_human_spot(@player1)

      if !game_is_over(@board) && !tie(@board)
        eval_board(@player2)
      end

      print_board
    end
  end

  def play_player1_vs_player2
      current_player = @player1

      until game_is_over(@board) || tie(@board)
        if current_player == @player1
          puts "Player 1, enter [0-8]:"
          get_human_spot(@player1)
        elsif current_player == @player2
          puts "Player 2, enter [0-8]:"
          get_human_spot(@player2)
        end

        print_board

        current_player == @player1 ? current_player = @player2 : current_player = @player1
      end
  end

  def play_computer_vs_computer
      until game_is_over(@board) || tie(@board)
        eval_board(@player1)
        print_board
        sleep 3

        if !game_is_over(@board) && !tie(@board)
          eval_board(@player2)
          print_board
          sleep 3
        end
      end
  end

  def print_board
    puts "\n #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n\n"
  end
end

game = Game.new
game.start_game
