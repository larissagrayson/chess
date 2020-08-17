#chess.rb

require_relative 'game_messages.rb'
require_relative 'chess_board.rb'
require_relative './pieces/king.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/rook.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/bishop.rb'
require_relative './pieces/pawn.rb'


# Constants
KNIGHT = "KNIGHT"
QUEEN  = "QUEEN"
BISHOP = "BISHOP"
KING   = "KING"
ROOK   = "ROOK"
PAWN   = "PAWN"

BLACK  = "BLACK"
WHITE  = "WHITE"

ROW    = 0
COL    = 1

class Chess
  include GameMessages

  def initialize
    @board = ChessBoard.new(8,8)
    @test_board = @board
    @current_player = WHITE
    @en_passant ={ possible?:             false,
                   pieces_eligible:       Array.new,
                   piece_to_be_captured:  Array.new,
                   location_to_move:      nil   }
    load_screen
  end

  def play_game
    place_pieces
    puts @board
    puts
    game_start_message
    puts "\nCurrent Player: #{@current_player}"
      move = nil
      until move !=nil
        move = request_user_move
        origin = move[0]
        destination = move[1]
        piece =  @board.piece_at(origin)
        if valid_move?(origin, destination) && correct_color?(origin) && !will_moving_put_king_in_check?(piece, destination)
          puts "VALID MOVE"
          execute_move(origin, destination)
          execute_post_move_actions(origin, destination)
          puts @board
          switch_player
          puts "\nCurrent Player: #{@current_player}"
          move = nil
          if check? && checkmate?
            game_over("checkmate")
            break
          elsif check?
            puts "#{@current_player} You are in check!!"
          elsif stalemate?
            game_over("stalemate")
            break
          end
        else
          puts "INVALID MOVE"
          move = nil
        end
      end
    end


private


   def game_over(type)
     if type == "checkmate"
       puts "Checkmate on #{@current_player}!!"
       puts "Game Over"
     elsif type ==  "stalemate"
       puts "Stalemate! Game Over"
     end
     # play_again
   end

  # Switches between players
  def switch_player
    if @current_player == WHITE
      @current_player = BLACK
    else
      @current_player = WHITE
    end
  end

  # Ensures the player tried to move only his piece color
  def correct_color?(origin)
    piece = @board.piece_at(origin)
    if piece.color != @current_player
      return false
    else
      return true
    end
  end

  # Intial setup of all pieces on the board
  def place_pieces
    # Place black pieces
    row = 1
    col = 0
    8.times do
      @board.place_piece(Pawn.new('black'), [row, col])
      col += 1
    end

    @board.place_piece(Rook.new('black'), [0,0])
    @board.place_piece(Knight.new('black'), [0,1])
    @board.place_piece(Bishop.new('black'), [0,2])
    @board.place_piece(Queen.new('black'), [0,3])
    @board.place_piece(King.new('black'), [0,4])
    @board.place_piece(Bishop.new('black'), [0,5])
    @board.place_piece(Knight.new('black'), [0,6])
    @board.place_piece(Rook.new('black'), [0,7])

    # Place white pieces
    row = 6
    col = 0
    8.times do
      @board.place_piece(Pawn.new('white'), [row, col])
      col += 1
    end

    @board.place_piece(Rook.new('white'), [7,0])
    @board.place_piece(Knight.new('white'), [7,1])
    @board.place_piece(Bishop.new('white'), [7,2])
    @board.place_piece(Queen.new('white'), [7,3])
    @board.place_piece(King.new('white'), [7,4])
    @board.place_piece(Bishop.new('white'), [7,5])
    @board.place_piece(Knight.new('white'), [7,6])
    @board.place_piece(Rook.new('white'), [7,7])
  end


    ## GAME RULE METHODS ##

  # Checks if the desired move is possible for the given piece
  def is_move_possible?(piece, origin, destination)
    moves = piece.get_all_possible_moves(origin)
    if moves.include?(destination)
      return true
    else
      return false
    end
  end

  # Checks if the path between the origin and destination is empty of other pieces
  def is_path_clear?(path)
    return @board.no_pieces_blocking_path?(path)
  end

  # Checks if space is empty at a given location
  def is_destination_empty?(destination)
    @board.space_empty?(destination)
  end

  #  Checks if enemy piece is at a given location
  def is_opponent_at_destination?(color, destination)
    if @board.space_empty?(destination)
      return false
    else
      dest_piece = @board.piece_at(destination)
      if dest_piece.color != color
        return true
      else
        return false
      end
    end
  end

  # Checks if a pawn is trying to move diagonally to capture
  def is_pawn_attempting_capture?(origin, destination)
    piece = @board.piece_at(origin)
    if piece.type == PAWN
      is_opponent_at_destination?(piece.color, destination) && piece.moving_diagonally?(origin, destination)
    else
      return false
    end
  end

  # 8/13 - CHECK IF ENPASSANT OR CASTLING ALSO POSSIBLE IN HERE?
  # Checks if the move the player requested is valid for the piece and destination
  def valid_move?(origin, destination)

    piece = @board.piece_at(origin)

    if piece == " "
       return false
    end

    path = piece.get_moves(origin, destination)
    if piece.type != PAWN && is_move_possible?(piece, origin, destination) && is_path_clear?(path) && (is_destination_empty?(destination) || is_opponent_at_destination?(piece.color, destination))
      return true
    elsif piece.type == PAWN && is_move_possible?(piece, origin, destination) && is_path_clear?(path) && is_destination_empty?(destination)
      return true
    elsif piece.type == PAWN && is_pawn_attempting_capture?(origin, destination)
      return true
    elsif piece.type == PAWN && enpassant_possible?(piece, destination)
      return true
    elsif piece.type == KING && castling_possible?(piece, origin, destination)
      return true
    else
      return false
    end
  end


  ## GAME ACTION METHODS ##

  # TESTED on 8/12  -# not being used...maybe remove??
  def capture_piece(location)
    @board.remove_piece(location)
  end

  # Moves the piece and sets appropriate conditions based on piece type
  def execute_move(origin, destination)
    piece = @board.piece_at(origin)

    if piece.type == ROOK && piece.first_move
        piece.first_move = false
        @board.remove_piece(destination)
        @board.move_piece(origin, destination)
    elsif piece.type == KING && castling_possible?(piece, origin, destination)
        perform_castling(piece, origin, destination)
    elsif piece.type == KING && piece.first_move
        piece.first_move = false
        @board.remove_piece(destination)
        @board.move_piece(origin, destination)
  elsif piece.type == PAWN && enpassant_possible?(piece, destination)
        perform_enpassant(piece)
    else
        @board.remove_piece(destination)
        @board.move_piece(origin, destination)
    end
  end

  # Performs post-move game actions (pawn promotions, enpassant setup, etc.)
  def execute_post_move_actions(origin, destination)
    clear_enpassant
    piece = @board.piece_at(destination)
    if piece.type == PAWN && promotion_possible?(destination)
        promote_pawn(piece, destination)
    elsif piece.type == PAWN && (destination[ROW] - origin[ROW]).abs == 2
        check_for_enpassant_conditions(piece)
    end
  end

   ## CHECK, CHECKMATE & STALEMATE METHODS ##

  # Check if King is under attack
  def check?
    king_location = find_king_location(@current_player)
    king = @board.piece_at(king_location)

    if king.color == WHITE
      opposing_color = BLACK
    else
      opposing_color = WHITE
    end

    opposing_pieces = @board.get_pieces(opposing_color)
    opposing_pieces.each do |piece|
      origin = @board.location_of_piece(piece)
      if valid_move?(origin, king_location)
        return true
      end
    end
    return false
  end

  # Determines if the game is in check mate
  def checkmate?#(king)
    king_location = find_king_location(@current_player)
    king = @board.piece_at(king_location)

    pieces = get_pieces_attacking_king(king, king_location)
    if pieces.empty?
      return false
    end
    attacker = pieces.first
    attacker_location = @board.location_of_piece(attacker)

    defending_pieces = @board.get_pieces(king.color)
    defending_pieces.delete(king)

    protectors = Array.new
    defending_pieces.each do |defender|
      if can_piece_protect_king?(defender, attacker) ||
        can_piece_capture_attacking_piece?(defender, attacker)
        if will_moving_put_king_in_check?(defender, attacker_location)
         protectors << false
        else
         protectors << true
        end
      end
    end

    if can_king_move_out_of_check?(king, king_location) || protectors.any?(true)
      return false
    else
      return true
    end

  end

  # Determines if the game is in a draw
  def stalemate?
    #1.) King is not in check
    king_location = find_king_location(@current_player)
    king = @board.piece_at(king_location)

    if check?#(king, king_location)
      return false
    end

    #2.) King cannot make any moves without going into check
    kings_valid_moves = get_all_valid_moves(king)
    king_move_into_check = Array.new
    kings_valid_moves.each do |move|
        if valid_move?(king_location, move)
          king_move_into_check << will_moving_put_king_in_check?(king, move)
        end
      end
    pieces = @board.get_pieces(king.color)
    pieces.delete(king)

    if king_move_into_check.all?(true) && !other_pieces_have_moves_left?(pieces)
      return true
    else
      return false
    end
  end

  # Returns an array of pieces attacking the king
  def get_pieces_attacking_king(king, king_location)
    attacking_pieces = Array.new
    if king.color == WHITE
      opposing_color = BLACK
    else
      opposing_color = WHITE
    end

    opposing_pieces = @board.get_pieces(opposing_color)

    opposing_pieces.each do |piece|
      origin = @board.location_of_piece(piece)
      if valid_move?(origin, king_location)
        attacking_pieces << piece
      end
    end
    return attacking_pieces
  end


  # Checks if king can make any moves without being checked
  def can_king_move_out_of_check?(king, king_location)
    kings_valid_moves = get_all_valid_moves(king)
    king_move_into_check = Array.new
    kings_valid_moves.each do |move|
        if valid_move?(king_location, move)
          king_move_into_check << will_moving_put_king_in_check?(king, move)
        end
      end

    if king_move_into_check.all?(true)
      return false
    else
      return true
    end
  end

  # Returns all valid moves for a piece
  def get_all_valid_moves(piece)
    origin = @board.location_of_piece(piece)
    possible_moves = piece.get_all_possible_moves(origin)


    valid_moves = Array.new
    if piece.type == KING
      possible_moves.each do |destination|
        if valid_move?(origin, destination) && !will_moving_put_king_in_check?(piece, destination) # check?#(piece, destination)
          valid_moves << destination
        end
      end
    else
      possible_moves.each do |destination|
        if valid_move?(origin, destination)
          valid_moves << destination
        end
      end
    end
    return valid_moves
  end

  # Checks if a player's pieces have any moves left
  def other_pieces_have_moves_left?(pieces)
    pieces_with_moves_left = Array.new
    pieces.each do |piece|
      valid_moves = get_all_valid_moves(piece)
        if !valid_moves.empty?
          pieces_with_moves_left << piece
        end
      end
    return !pieces_with_moves_left.empty?
  end

  # Checks if a piece can block a piece attacking the king
  def can_piece_protect_king?(piece, attacking_piece)
    current_location = @board.location_of_piece(piece)
    king_location = find_king_location(piece.color)
    attacker_location = @board.location_of_piece(attacking_piece)
    attacking_path = attacking_piece.get_moves(attacker_location, king_location)
    possible_moves = piece.get_all_possible_moves(current_location)

    # Are any of the pieces possible moves along the attacking path?
    attacking_path.each do |move|
      if possible_moves.any?(move) && valid_move?(current_location, move)
        return true
      end
    end
    return false
  end

  # Checks if  a piece can capture a piece attacking the king
  def can_piece_capture_attacking_piece?(piece, attacking_piece)
    origin = @board.location_of_piece(piece)
    destination = @board.location_of_piece(attacking_piece)
    return valid_move?(origin, destination)
  end

  def will_moving_put_king_in_check?(piece, destination)
    if piece.type == ROOK || piece.type == KING || piece.type == PAWN
       first_move = piece.first_move
     end
    origin = @board.location_of_piece(piece)
    temp_captured_piece = @board.piece_at(destination)
    if valid_move?(origin, destination)
      @board.remove_piece(destination)
      @board.move_piece(origin, destination)
      king_location = find_king_location(piece.color)
      king = @board.piece_at(king_location)

      if check?#(king, king_location)
        result = true
      else
        result = false
      end
      @board.move_piece(destination, origin)
      if piece.type == ROOK || piece.type == KING || piece.type == PAWN
          piece.first_move = first_move
       end
      @board.place_piece(temp_captured_piece, destination)


    else
      result = false
    end
    return result
  end

  # Find the king's location on the board
  def find_king_location(color)
    pieces = @board.get_pieces(color)
    if pieces.any?(King)
      index = pieces.index{|piece| piece.type == KING}
      king = pieces[index]
      return @board.location_of_piece(king)
    else
      return nil
    end
  end


  ## EN PASSANT METHODS ##


  # This method will check if en passant conditions are present after a pawn has moved
  def check_for_enpassant_conditions(pawn)
    clear_enpassant
    current_location = @board.location_of_piece(pawn)
    current_row = current_location[ROW]
    current_col = current_location[COL]

    left_side = [current_row, current_col-1]
    right_side =[current_row, current_col+1]
    left_enemy = nil
    right_enemy = nil



    if is_opponent_at_destination?(pawn.color, left_side)
      left_enemy = @board.piece_at(left_side)
      if !left_enemy.nil?
        @en_passant[:pieces_eligible] << left_enemy
      end
    end

    if is_opponent_at_destination?(pawn.color, right_side)
      right_enemy = @board.piece_at(right_side)
      if !right_enemy.nil?
        @en_passant[:pieces_eligible] << right_enemy
      end
    end

    if (left_enemy != nil && left_enemy.type == PAWN) || (right_enemy != nil && right_enemy.type == PAWN)
      # set en_passant flag to true
      @en_passant[:possible?] = true

      # add piece to be captured
      @en_passant[:piece_to_be_captured] = pawn

      # add location enemy piece can move to
      if pawn.color == WHITE
        # enemy is black & space to move to would be 1 down
        location = [current_row+1, current_col]
        @en_passant[:location_to_move] = location
      else # enemy is white & space would be 1 up
        location = [current_row+-1, current_col]
        @en_passant[:location_to_move] = location
      end
    end
  end


  # Called when a pawn is trying to move diagonally 1 space to empty space
  def enpassant_possible?(pawn, destination)
    if @en_passant[:possible?] == true && @en_passant[:pieces_eligible].any?(pawn) && @en_passant[:location_to_move] == destination
      return true
    else
      return false
    end
  end

  # Moves pawn diagonally and captures piece in passing
  def perform_enpassant(pawn)
    # First capture the pawn in passing
    captured_piece = @en_passant[:piece_to_be_captured]
    location = @board.location_of_piece(captured_piece)
    @board.remove_piece(location)

    # move to destination
    origin = @board.location_of_piece(pawn)
    destination = @en_passant[:location_to_move]
    @board.move_piece(origin,destination)
  end


  # Clears en_passant condition from the game
  def clear_enpassant
    # set enpassant hash to nil
    @en_passant ={ possible: false,
                  pieces_eligible: Array.new,
                  piece_to_be_captured:  Array.new,
                  location_to_move:  nil}
  end


   ## PAWN PROMOTION METHODS ##


  # Checks if the pawn can be promoted
  def promotion_possible?(destination)
   destination[ROW] == 7 || destination[ROW] == 0
  end

  # Prompts user for promotion choices and promotes pawn
  def promote_pawn(promoted_pawn, destination)
   color = promoted_pawn.color
   location = @board.location_of_piece(promoted_pawn)
   @board.remove_piece(location)
   puts "Your pawn has been promoted!!"
   answer = nil
   until answer !=nil
       print "What piece would you like your pawn to become? ((Q)ueen, (R)ook, (K)night or (B)ishop?): "
     answer = gets.chomp.upcase
     case answer
     when "Q"
       promoted_pawn = Queen.new(color)
     when "R"
       promoted_pawn = Rook.new(color)
     when "K"
       promoted_pawn = Knight.new(color)
     when "B"
       promoted_pawn = Bishop.new(color)
     else
       answer = nil
     end
   end
   @board.place_piece(promoted_pawn, destination)
   #puts @board
  end

  ## CASTLING METHODS ##

  # Checks if castling is possible for the King
  def castling_possible?(king, origin, destination)
    # Check if king can castle
    potential_rook = get_rook_for_castling(origin, destination)
    if potential_rook == " "
      return false
    elsif potential_rook.type != ROOK
      return false
    elsif !potential_rook.first_move
      return false
    elsif !king.can_castle?(origin, destination)
      return false
    end

    kings_moves = king.get_moves(origin, destination)

    king_move_into_check = Array.new
    kings_moves.each do |move|
      king_move_into_check << check?#(king, move)
    end

    if king_move_into_check.all?(false) && is_path_clear?(kings_moves) && is_destination_empty?(destination)
      return true
    else
      return false
    end
  end

  # Actual move of castling
  def perform_castling(king, origin, destination)
    rook = get_rook_for_castling(origin, destination)
    rook_origin = @board.location_of_piece(rook)

    # Move the king
    @board.move_piece(origin, destination)
    king.first_move = false

    # Move the rook
    if rook_origin[COL] == 7
      rook_destination = [rook_origin[ROW], 5]
      @board.move_piece(rook_origin, rook_destination)
      rook.first_move = false
    else
      rook_destination = [rook_origin[ROW], 3]
      @board.move_piece(rook_origin, rook_destination)
      rook.first_move = false
    end
  end


  # Gets the rook that will castle with the king
  def get_rook_for_castling(origin, destination)
    direction = destination[COL] - origin[COL]
    if direction > 0  # moving right
      @board.piece_at([origin[ROW], 7])
    else
      @board.piece_at([origin[ROW], 0])
    end
  end

end # End of Chess Class


game = Chess.new
