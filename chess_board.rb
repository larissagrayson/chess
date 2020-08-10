# chess_board.rb

require_relative './pieces/king.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/rook.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/bishop.rb'
require_relative './pieces/pawn.rb'

class Board
  attr_accessor :board

  def initialize(row, col, board_title="")
    @MAX_ROW = row
    @MAX_COL = col
    @board = Array.new(@MAX_ROW) {Array.new(@MAX_COL, " ")}
    @board_title = board_title
  end

  # Prints the board to the console
  def to_s
    str = String.new(@board_title)
    @board.each do |row|
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

  # Checks if the requested location is empty and within the bounds of the board
  def valid_location?(location)
    row = location[0]
    col = location[1]
    if row < 0 || row >= @MAX_ROW
      return false
    elsif col < 0 || col >= @MAX_COL
      return false
    elsif @board[row][col] != " "
      return false
    else
      return true
    end
  end

  # Places a piece in the given location
  def place_piece(piece, new_location)
    row = new_location[0]
    col = new_location[1]
    if valid_location?(new_location)
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
    if valid_location?(destination)
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

  def is_space_empty?(location)
    row = location[0]
    col = location[1]
    return @board[row][col] == " "
  end

end # End of ChessBoard Class


# Test Script #



board = Board.new(8,8)
black_king = King.new('black')
black_queen = Queen.new('black')
black_rook_1 = Rook.new('black')
black_rook_2 = Rook.new('black')
black_knight_1 = Knight.new('black')
black_knight_2 = Knight.new('black')
black_bishop_1 = Bishop.new('black')
black_bishop_2 = Bishop.new('black')
num = 1
row = 1
col = 0
8.times do
  black_pawn_num = Pawn.new('black')
  num += 1
  board.place_piece(black_pawn_num, [row, col])
  col += 1
end

board.place_piece(black_rook_1, [0,0])
board.place_piece(black_knight_1, [0,1])
board.place_piece(black_bishop_1, [0,2])
board.place_piece(black_queen, [0,3])
board.place_piece(black_king, [0,4])
board.place_piece(black_bishop_2, [0,5])
board.place_piece(black_knight_2, [0,6])
board.place_piece(black_rook_2, [0,7])



white_king = King.new('white')
white_queen = Queen.new('white')
white_rook_1 = Rook.new('white')
white_rook_2 = Rook.new('white')
white_knight_1 = Knight.new('white')
white_knight_2 = Knight.new('white')
white_bishop_1 = Bishop.new('white')
white_bishop_2 = Bishop.new('white')
num = 1
row = 6
col = 0
8.times do
  white_pawn_num = Pawn.new('white')
  num += 1
  board.place_piece(white_pawn_num, [row, col])
  col += 1
end

board.place_piece(white_rook_1, [7,0])
board.place_piece(white_knight_1, [7,1])
board.place_piece(white_bishop_1, [7,2])
board.place_piece(white_queen, [7,3])
board.place_piece(white_king, [7,4])
board.place_piece(white_bishop_2, [7,5])
board.place_piece(white_knight_2, [7,6])
board.place_piece(white_rook_2, [7,7])


puts board

board.move_piece([6,0], [5,0])
puts
puts board
