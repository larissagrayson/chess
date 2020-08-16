# bishop.rb
require_relative 'chess_piece.rb'

class Bishop < ChessPiece

  # Constants
  BISHOP     = "BISHOP"
  BLACK      = "BLACK"
  WHITE      = "WHITE"
  ROW        = 0
  COL        = 1

  def initialize(color)
    color = color.upcase
    if color == BLACK
      unicode="\u265D"
    else
      unicode="\u2657"
    end
    super(type=BISHOP, color, unicode)
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

  # Returns an array of all moves a bishop could possibly take
  def get_all_possible_moves(starting_location)
    start_row = starting_location[ROW]
    start_col = starting_location[COL]
    moves = Array.new

    # up left
    col = start_col
    row = start_row
    while col > 0 && row > 0
      moves << [row-1, col-1]
      col-=1
      row-=1
    end

    # down right
    col = start_col
    row = start_row
    while col < 7 && row < 7
      moves << [row+1, col+1]
      col+=1
      row+=1
    end

    # up right
    col = start_col
    row = start_row
    while col < 7 && row > 0
      moves << [row-1, col+1]
      col+=1
      row-=1
    end
    # down left
    col = start_col
    row = start_row
    while row < 7 && col > 0
      moves << [row+1, col-1]
      col-=1
      row+=1
    end
   return moves
  end

end # End of Bishop Class
