# pawn.rb

require_relative 'chess_piece.rb'

class Pawn < ChessPiece

  # Constants
  ROW = 0

  def initialize(color)
    if color.upcase == "BLACK"
      unicode="\u265F"
    else
      unicode="\u2659"
    end
    super(type="Pawn", color, unicode)
  end

  # Checks if the move is 1 space up
  def valid_move?(origin, destination)
    return (destination[ROW] - origin[ROW]) == -1
  end

 # Returns an array of spaces crossed in move
  def get_moves(origin, destination)
    moves = Array.new([origin])
    moves << [destination]
    return moves
  end
end # end of Pawn Class
