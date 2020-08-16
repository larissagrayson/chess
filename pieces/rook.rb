# rook.rb

require_relative 'chess_piece.rb'

class Rook < ChessPiece

  attr_accessor :first_move

  # Constants
  BLACK = "BLACK"
  ROOK  = "ROOK"
  ROW   = 0
  COL   = 1

  def initialize(color)
    color = color.upcase
    if color == BLACK
      unicode="\u265C"
    else
      unicode="\u2656"
    end
    super(type=ROOK, color, unicode)
    @first_move = true
  end

  # Checks if the move is in a straight line along a row or column
  def valid_move?(origin, destination)
    if origin[ROW] == destination[ROW]
      return true
    elsif origin[COL] == destination[COL]
      return true
    else
      return false
    end
  end

  # Returns an array of all squares crossed to get to destination
  def get_moves(origin, destination)
    moves = Array.new([origin])

    # Moving up/down
    if origin[COL] == destination[COL]
      dest_row = destination[ROW]
      start_row = origin[ROW]

      # Moving up
      if dest_row-start_row > 0
        next_row = start_row + 1
        while next_row <= dest_row
          next_space = [next_row, destination[COL]]
          next_row += 1
          moves << next_space
        end

      # Moving down
      else
        next_row = start_row-1
        while next_row >= dest_row
          next_space = [next_row, destination[COL]]
          next_row -=1
          moves << next_space
        end
      end

    # Moving left/right
    elsif origin[ROW] == destination[ROW]
      dest_col = destination[COL]
      start_col = origin[COL]

      # Moving right
      if dest_col-start_col > 0
        next_col = start_col + 1
        while next_col <= dest_col
          next_space = [destination[ROW], next_col]
          next_col += 1
          moves << next_space
        end

      # Moving left
      else
        next_col = start_col-1
        while next_col >= dest_col
          next_space = [destination[ROW], next_col]
          next_col -= 1
          moves << next_space
        end
      end
    end
    return moves
  end

  # Returns an array of all moves a rook could possibly take
  def get_all_possible_moves(starting_location)
    start_row = starting_location[ROW]
    start_col = starting_location[COL]
    moves = Array.new
    col = 0
    row = 0
    # get all possible horizontal moves
    while col <= 7
      moves << [start_row, col]
      col += 1
    end
    # get all possible vertical moves
    while row <= 7
      moves << [row, start_col]
      row += 1
    end
    moves.delete(starting_location)
    return moves
  end
end  #end of Rook class
