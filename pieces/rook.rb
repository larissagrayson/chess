# rook.rb

require_relative 'chess_piece.rb'

class Rook < ChessPiece

  # Constants
  ROW = 0
  COL = 1

  def initialize(color)
    if color.upcase == "BLACK"
      unicode="\u265C"
    else
      unicode="\u2656"
    end
    super(type="Rook", color, unicode)
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

end  #end of Rook class
