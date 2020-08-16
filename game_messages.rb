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
    puts "Game Rules"
    # Explain game simply and then provide link to wikipedia for more info"
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
