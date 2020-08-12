# chess_board.rb

require_relative './pieces/king.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/rook.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/bishop.rb'
require_relative './pieces/pawn.rb'

class Board
  attr_accessor :board

  def initialize(row, col)
    @MAX_ROW = row
    @MAX_COL = col
    @board = Array.new(@MAX_ROW) {Array.new(@MAX_COL, " ")}
    @board_title = "    A   B   C   D   E   F   G   H\n"
  end

  # Prints the board to the console
  def to_s
    str = String.new(@board_title)
    @board.each_with_index do |row, index|
      str += index.to_s + " "
      str += "|"
      row.each do |space|
        if space == " "
          str+= " - "
      else
        str += " " + space.to_s + " "
      end
        str += "|"
      end
    str += "\n"
    end
    str
  end

  # Checks if the board is full of pieces
  def is_full?
    @board.each do |row|
      if row.any?(" ") == true
        return false
      else
        return true
      end
    end
  end

  # Checks if the requested location is within the bounds of the board
  def is_location_on_board?(location)
    row = location[0]
    col = location[1]
    if row < 0 || row > @MAX_ROW
      return false
    elsif col < 0 || col > @MAX_COL
      return false
  #  elsif @board[row][col] != " "
    #  return false
    else
      return true
    end
  end

  # Places a piece in the given location
  def place_piece(piece, new_location)
    row = new_location[0]
    col = new_location[1]
    if is_location_on_board?(new_location) && space_empty?(new_location)
      @board[row][col] = piece
    end
  end

  # Removes a piece from the given location
  def remove_piece(location)
    row = location[0]
    col = location[1]
    @board[row][col] = " "
  end

  # Moves the piece on the board and sets start location to blank
  def move_piece(origin, destination)
    if is_location_on_board?(destination)
      piece = piece_at(origin)
      remove_piece(origin)
      place_piece(piece, destination)
    end
  end

  # Returns the piece at the given location
  def piece_at(location)
    row = location[0]
    col = location[1]
    return @board[row][col]
  end

## CLEAN UP
  def location_of_piece(piece)
    location = Array.new
      @board.each_with_index do |row, r_index|
        row.each_with_index do |space, c_index|
          if space == piece
            location[0] = r_index
            location[1] = c_index
            break
          end
        end
      end
    location
  end

  # Checks if a given space is empty
  def space_empty?(location)
    row = location[0]
    col = location[1]
    return @board[row][col] == " "
  end

  # Checks if there are any pieces occupying a given set of spaces
  def pieces_blocking_path?(path)
    result = Array.new
    path = path[1..-2]
    path.each do |space|
      result << space_empty?(space)
    end

    # return result.all?(true) ** BETTER
    if result.any?(false) # some spaces are not empty
      return true
    else
      return false
    end
  end

end # End of ChessBoard Class
