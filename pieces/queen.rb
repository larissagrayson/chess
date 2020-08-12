# queen.rb

require_relative 'chess_piece.rb'

class Queen < ChessPiece

  # Constants
  DIAGONAL   = "DIAGONAL"
  HORIZONTAL = "HORIZONTAL"
  VERTICAL   = "VERTICAL"
  ROW        = 0
  COL        = 1

  def initialize(color)
    if color.upcase == "BLACK"
      unicode="\u265B"
    else
      unicode="\u2655"
    end
    super(type="Queen", color, unicode)
  end

  # Checks if the move is on a diagonal, horizontal, or vertical
def valid_move?(origin, destination)
  # check if horizontal or vertial
  direction = get_direction(origin, destination)
  if direction == HORIZONTAL || direction == VERTICAL || direction == DIAGONAL
    return true
  else
    return false
  end
end

# Returns an array of all the squares crossed to get to the destination
def get_moves(origin, destination)
  direction = get_direction(origin, destination)
  if direction == HORIZONTAL || direction == VERTICAL
    moves = get_horizontal_vertical_moves(origin, destination)
  elsif direction == DIAGONAL
    moves = get_diagonal_moves(origin, destination)
  else
    moves = nil
  end
  return moves
end

  # Returns an array of all moves a queen could possibly take
  def get_all_possible_moves(starting_location)
    start_row = starting_location[ROW]
    start_col = starting_location[COL]
    moves = Array.new

    # get all possible horizontal moves
    col = 0
    row = 0
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

  private

    # Returns the direction of the move between origin and destination
    def get_direction(origin, destination)
      if origin[ROW] == destination[ROW]
        return HORIZONTAL
      elsif origin[COL] == destination[COL]
        return VERTICAL
      elsif
        difference_between_rows = (destination[ROW] - origin[ROW])
        difference_between_cols = (destination[COL] - origin[COL])
        difference_between_rows.abs == difference_between_cols.abs
        return DIAGONAL
      else
        return nil
      end
    end

    # Returns all spaces crossed if horizontal or vertical move
    def get_horizontal_vertical_moves(origin, destination)
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

    # Returns all spaces crossed if diagonal move
    def get_diagonal_moves(origin, destination)
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




end # end of Queen Class


queen = Queen.new('black')
puts "Starting location: [4,3]"
moves = queen.get_all_possible_moves([7,7])
print moves
puts
