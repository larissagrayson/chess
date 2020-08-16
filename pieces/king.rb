# king.rb

require_relative 'chess_piece.rb'



class King < ChessPiece
  attr_accessor :first_move

  # Constants
  DIAGONAL   = "DIAGONAL"
  HORIZONTAL = "HORIZONTAL"
  VERTICAL   = "VERTICAL"
  KING       = "KING"
  BLACK      = "BLACK"
  WHITE      = "WHITE"
  ROW        = 0
  COL        = 1

  def initialize(color)
    color = color.upcase
    if color == BLACK
      unicode="\u265A"
    else
      unicode="\u2654"
    end
    super(type=KING, color, unicode)
    @first_move = true
  end

  # Checks if the move is on a diagonal, horizontal, or vertical
  def valid_move?(origin, destination)
    difference_between_rows = (destination[ROW] - origin[ROW])
    difference_between_cols = (destination[COL] - origin[COL])

    if (origin[ROW] == destination[ROW]) &&
       (difference_between_cols.abs == 1)
      return true
    elsif (origin[COL] == destination[COL]) &&
          (difference_between_rows.abs == 1)
      return true
    elsif (difference_between_rows.abs == difference_between_cols.abs) &&
          (difference_between_rows.abs == 1) &&
          (difference_between_cols.abs == 1)
      return true
    else
      return false
    end
  end

  # Checks if a King can perform Castling
  def can_castle?(origin, destination)
    difference_between_cols = (destination[COL] - origin[COL])

    if (origin[ROW] == destination[ROW]) &&  @first_move && (difference_between_cols.abs == 2)
      (@color == BLACK && origin[ROW] == 0) || (@color == WHITE && origin[ROW] == 7)
    else
      false
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

  # Returns an array of all possible moves based on current location
  def get_all_possible_moves(starting_location)
    moves = Array.new
    row = starting_location[ROW]
    col = starting_location[COL]
    moves << [row+1, col]   # down 1 space
    moves << [row-1, col]   # up 1 space
    moves << [row, col+1]   # right 1 space
    moves << [row, col-1]   # left 1 space
    moves << [row-1, col-1] # up-left 1 space
    moves << [row-1, col+1] # up-right 1 space
    moves << [row+1, col-1] # down-left 1 space
    moves << [row+1, col+1] # up-right 1 space

    moves.delete_if do |move|
      move[ROW] > 7 || move[ROW] < 0 || move[COL] > 7 || move[COL] < 0
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
end # end of King Class
