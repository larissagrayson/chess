# pawn.rb

require_relative 'chess_piece.rb'


class Pawn < ChessPiece

  attr_accessor :first_move

  # Constants
  ROW   = 0
  COL   = 1
  BLACK = "BLACK"
  WHITE = "WHITE"
  PAWN  = "PAWN"

  def initialize(color)
    color = color.upcase
    if color == BLACK
      unicode="\u265F"
    else
      unicode="\u2659"
    end

    super(type=PAWN, color, unicode)
    @first_move = true
  end

  # Checks if the move is 1 or 2 spaces forward
  def valid_move?(origin, destination)
    distance = destination[ROW] - origin[ROW]
    if destination[COL] != origin[COL]
      return false
    elsif @color == BLACK
      if (distance == 2 && @first_move)
        return true
      elsif (distance == 1)
        return true
      else
        return false
      end
    elsif @color == WHITE
      if (distance == -2 && @first_move)
      elsif (distance == -1)
        return true
      else
        return false
      end
    else
      return false
    end
  end

 # Returns an array of spaces crossed in move
  def get_moves(origin, destination)
    moves = Array.new([origin])
    moves << [destination]
    return moves
  end

  # Returns an array of all moves a pawn could possibly take
  def get_all_possible_moves(starting_location)
    start_row = starting_location[ROW]
    start_col = starting_location[COL]
    moves = Array.new
    if @color == BLACK && start_row == 1
      moves << [start_row+1, start_col]
      moves << [start_row+2, start_col]
    elsif @color == BLACK
        moves << [start_row+1, start_col]
    elsif @color == WHITE && start_row == 6
        moves << [start_row-1, start_col]
        moves << [start_row-2, start_col]
    else
      moves << [start_row-1, start_col]
    end

    moves.delete_if do |move|
      move[ROW] > 7 || move[ROW] < 0 || move[COL] > 7 || move[COL] < 0
    end

    return moves
  end

  # Checks if the pawn is trying to move diagonally
  # Needed for en_passant and captures
  def moving_diagonally?(origin, destination)
    row_diff = destination[ROW] - origin[ROW]
    col_diff = (destination[COL] - origin[COL]).abs
    # Moving 1 space on a diagonal
    if col_diff == 1 && row_diff.abs == 1
      # Black is moving down
      if @color == BLACK && row_diff == 1
        return true
      # White is moving up
      elsif @color == WHITE && row_diff == -1
        return true
      end
    end
    return false
  end
end # end of Pawn Class

pawn = Pawn.new('black')
puts "Starting location: [1,1]"
moves = pawn.get_all_possible_moves([1,1])
print moves
