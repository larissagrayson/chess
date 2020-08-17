# game_messages.rb

module GameMessages

  # Initial Load Screen
  def load_screen
    puts "\n Let's Play Chess!"
    puts "Please select an option below..."
    puts "[1] New Game"
    puts "[2] Load Game"
    puts "[3] Rules"
    puts "[4] Exit"
    print ">> "
    response = gets.chomp.upcase

    case response
    when "1"
      puts "Starting new game..."
      play_game
    when '2'
      puts "Loading game..."
      load_game
    when "3"
      rules
    when '4'
      exit!
    else
      load_screen
    end
  end

  # Displays game rules
  def rules
    system ("clear")

    puts "\n\t\t\t RULES\n"
    puts "Chess is a board game played with 2 players (WHITE & BLACK). WHITE \nalways starts first and play continues by alternating between colors. \nWHITE pieces are located at the bottom two rows of the board and BLACK is \nlocated on the top two rows. Each player has 16 pieces: 1 KING, 1 QUEEN, \n2 ROOKS, 2 KNIGHTS, 2 BISHOPS, and 8 PAWNS.\n\n"

    puts "\t\t\t OBJECTIVE\n"
    puts "The objective of the game is to use your pieces to put the opponent's \nKING under threat of capture (CHECK) without any possible way to escape \n(CHECKMATE). If there are no possible moves left for either player and \nthe KING is not in check, the game will end in a draw (STALEMATE).\n\n"

    puts "\t\t\t PIECES\n"
    puts "A piece cannot land on a square occupied by a friendly piece. If a \npiece lands on a square occupied by an opponent's piece, then that piece \nis considered \"captured\" and removed from the board. Pieces may not \njump over other pieces, except for the KNIGHT.
    \nKING - Can move 1 square in any direction, but cannot move to a space that \nwill put him in check
    \nROOK - Can move any number of squares in a straight line (horizontally or \nvertically).
    \nBISHOP - Can move any number of squares diagonally.
    \nQUEEN - The most powerful piece in the game. Combines the movements of the \nROOK and BISHOP.
    \nKNIGHT - Can move in any direction in an L-shape pattern (2 spaces in one \ndirection and 1 space at a right angle).
    \nPAWN - Can only move forward 1 space at a time, unless it's his first \nmove, then he can move up to two squares at a time.\n\n"

    puts "\t\t\tSPECIAL MOVES\n"
    puts "CASTLING - Once per game, each player may move their KING 2 spaces to \nthe left or right toward a ROOK. The ROOK then is placed on thesquare \nbeside the KING towards the center of the board. This move can only be \ndone if the KING and ROOK are on their first move and the KING does not \nmove from check, out of check, or through check.
    \nPROMOTION - When a PAWN reaches the opposite end of the board, it can be \npromoted. The player can choose to promote their PAWN to a QUEEN, ROOK, \nBISHOP, or KNIGHT.
    \nEN PASSANT - Occurs when a PAWN makes a 2 step advance from its starting \nposition and ends up next to an opposing PAWN. On the very next turn, the \nopponent may capture him \"in passing\" by moving diagonally behind him. \nIf this is not taken in the next turn, it is forfeited.\n\n"


    puts "[1] Go Back"
    puts "[2] New Game"
    print ">> "

    response = gets.chomp.upcase

    case response
    when "1"
      load_screen
    when "2"
      #play_game
    else
      rules
    end
  end

  def load_game
    puts "LOADING GAME GOES HERE"
  end

  def save_game
    puts "SAVE GAME HERE"
  end

  # Display game start message
  def game_start_message
    puts "Please enter all moves in the form of: \'a2:a3\'"
    puts "If at any time you'd like to quit, enter \'Q\'."
  end

  # Prompt user for input
  def request_user_move
    print "Please enter your desired move >> "
    response = gets.chomp.upcase

     if response == "Q"
       quit
       return
     else
       desired_move = validate_input(response)
     end
  end

  # Validates the input the user provided
  def validate_input(response)

    move = response.upcase.split(":").join

    valid_cols= ('A'..'H').to_a
    valid_rows=(1..8).to_a

    if move.length != 4
      puts "Error! Invalid input"
      request_user_move
    elsif !valid_cols.include?(move[0] && move[2]) && !valid_rows.include?(move[1] && move[3])
      puts "Error! Invalid input"
      request_user_move
    else
      response = convert_input(move)
      return response
    end
  end

  #DONE - clean up puts statements though & where what/who will get the conversion? -- global variables, return to another method?
  def convert_input(move)

  #User input is in the form of: [origin_COL, origin_ROW, destination_COL, destination_ROW] & numbering starts at 1 beginning at the bottom left square

   # Need to convert to the internal computer form of: origin[row, col] & destination[row, col] with numbering being zero offset and starting in upper left

    origin_row = 8-(move[1].to_i)
    origin_col = (move[0].each_byte.first)-65  # Converts uppercase char to number

    destination_row = 8-(move[3].to_i)
    destination_col = (move[2].each_byte.first)-65

     return [[origin_row, origin_col],[destination_row, destination_col]]

  end


  # Display game quit message
  def quit
    print "\nAre you sure you want to quit? (Y)/(N)"
    response = gets.chomp.upcase
    if response == "Y"
      prompt_for_save
    else
      request_user_move
    end
  end

  # Prompts the user for save
  def prompt_for_save
    print "\nWould you like to save your game? (Y)/(N)"
    response = gets.chomp.upcase
    if response == "Y"
      save_game
    else
      exit!
    end
  end


#game_start_message
#load_screen

#validate_input("h2:h")
end # End of GameMessages Module
