# bishop.rb
require_relative 'chess_piece.rb'

class Bishop < ChessPiece

    # Constants
    ROW = 0
    COL = 1
  def initialize(color)
    if color.upcase == "BLACK"
      unicode="\u265D"
    else
      unicode="\u2657"
    end
    super(type="Bishop", color, unicode)
  end

  # Checks if the move is on a diagonal
  def valid_move?(origin, destination)
    difference_between_rows = (destination[ROW] - origin[ROW])
    difference_between_cols = (destination[COL] - origin[COL])
    if difference_between_rows.abs == difference_between_cols.abs
      return true
    else
      return false
    end
  end

  # Returns an array of all squares crossed to get to destination
  def get_moves(origin, destination)
    moves = Array.new([origin])
    difference_btw_rows = (destination[ROW] - origin[ROW])
    difference_btw_cols = (destination[COL] - origin[COL])
    start_row = origin[ROW]
    dest_row  =  destination[ROW]
    start_col = origin[COL]
    dest_col = destination[COL]

    # Moving on an up-right diagonal
    if difference_btw_rows > 0 && difference_btw_cols > 0
      next_row = start_row + 1
      next_col = start_col + 1
      while next_row <= dest_row && next_col <= dest_col
        next_space = [next_row, next_col]
        next_row += 1
        next_col += 1
        moves << next_space
      end
    # Moving on a down-right diagonal
    elsif difference_btw_rows > 0 && difference_btw_cols < 0
      next_row = start_row + 1
      next_col = start_col - 1
      while next_row <= dest_row && next_col >= dest_col
        next_space = [next_row, next_col]
        next_row += 1
        next_col -= 1
        moves << next_space
      end
    # Moving on a down-left diagonal
    elsif difference_btw_rows < 0 && difference_btw_cols < 0
      next_row = start_row - 1
      next_col = start_col - 1
      while next_row >= dest_row && next_col >= dest_col
        next_space = [next_row, next_col]
        next_row -= 1
        next_col -= 1
        moves << next_space
      end
    # Moving on an up-left diagonal
    else
      next_row = start_row - 1
      next_col = start_col + 1
      while next_row >= dest_row && next_col <= dest_col
        next_space = [next_row, next_col]
        next_row -= 1
        next_col += 1
        moves << next_space
      end
    end
    return moves
  end
end # End of Bishop Class
