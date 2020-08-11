# pawn.rb

require_relative 'chess_piece.rb'


class Pawn < ChessPiece

  attr_reader :first_move

  # Constants
  ROW = 0
  BLACK = "BLACK"
  WHITE = "WHITE"

  def initialize(color)
    if color.upcase == BLACK
      unicode="\u265F"
    else
      unicode="\u2659"
    end

    super(type="Pawn", color.upcase, unicode)
    @first_move = true
  end

  # Checks if the move is 1 or 2 spaces forward
  def valid_move?(origin, destination)
    distance = destination[ROW] - origin[ROW]
    if @color == BLACK
      if (distance == 2 && @first_move)
        @first_move = false
        return true
      elsif (distance == 1)
        if @first_move
          @first_move = false
        end
        return true
      else
        return false
      end
    elsif @color == WHITE
      if (distance == -2 && @first_move)
        @first_move = false
        return true
      elsif (distance == -1)
        if @first_move
          @first_move = false
        end
        return true
      else
        return false
      end
    else
      return false
    end
  end

 # Returns an array of spaces crossed in move
  def get_moves(origin, destination)
    moves = Array.new([origin])
    moves << [destination]
    return moves
  end
end # end of Pawn Class
