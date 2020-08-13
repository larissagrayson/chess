# knight.rb

require_relative 'chess_piece.rb'

class Knight < ChessPiece

  # Constants
  KNIGHT = "KNIGHT"
  BLACK  = "BLACK"
  ROW    = 0
  COL    = 1

  def initialize(color)
    color = color.upcase
    if color == BLACK
      unicode = "\u265E"
    else
      unicode = "\u2658"
    end
    super(type= KNIGHT, color, unicode)
  end

  # Checks if the move is L-Shape
  def valid_move?(origin, destination)
    if (destination[ROW] - origin[ROW]).abs == 2 && (destination[COL]- origin[COL]).abs == 1
      return true
    elsif (destination[ROW] - origin[ROW]).abs == 1 && (destination[COL]- origin[COL]).abs == 2
      return true
    else
      return false
    end
  end

  # Returns all squares crossed to get to destination
  def get_moves(origin, destination)
    moves = [origin, destination]
  end


  # Returns an array of all moves a knight could possibly take
  def get_all_possible_moves(starting_location)
    start_row = starting_location[ROW]
    start_col = starting_location[COL]
    moves = Array.new

     moves << [start_row-2, start_col+1]
     moves << [start_row-2, start_col-1]
     moves << [start_row+2, start_col+1]
     moves << [start_row+2, start_col-1]

     moves << [start_row-1, start_col+2]
     moves << [start_row-1, start_col-2]
     moves << [start_row+1, start_col+2]
     moves << [start_row+1, start_col-2]

     moves.delete_if do |move|
       move[ROW] > 7 || move[ROW] < 0 || move[COL] > 7 || move[COL] < 0
     end

   return moves
  end
end # end of Knight Class

knight = Knight.new('white')
puts "Starting location: [4,3]"
moves = knight.get_all_possible_moves([0,0])
print moves
puts
