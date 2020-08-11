# knight.rb

require_relative 'chess_piece.rb'

class Knight < ChessPiece

  # Constants
  KNIGHT = "KNIGHT"
  BLACK  = "BLACK"
  ROW    = 0
  COL    = 1

  def initialize(color)
    if color.upcase == BLACK
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
end # end of Knight Class
