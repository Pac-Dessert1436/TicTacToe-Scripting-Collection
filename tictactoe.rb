board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
message = ""
current_player = 1  # 1 for X, 2 for O

def is_board_filled(board)
    board.flatten.none? { |cell| cell == 0 }
end

def print_board(board, message)
    puts "\x1b[H\x1b[2J"
    puts "\n  0 1 2"
    board.each_with_index do |row, i|
        print "#{i} "
        row.each do |cell|
            symbol = case cell
                        when 1 then 'X'
                        when 2 then 'O'
                        else '.'
                    end
            print "#{symbol} "
        end
        puts
    end
    puts message
end

def get_player_move(board, current_player, message)
    loop do
        print_board(board, message)
        print "Player #{current_player == 1 ? 'X' : 'O'}'s turn. Enter row and column (0-2): "
        input = gets.chomp.split.map(&:to_i)
        
        if input.length < 2
            message = "Invalid input. Enter two numbers."
            next
        end
        
        row, col = input[0], input[1]
        
        if row < 0 || row > 2 || col < 0 || col > 2
            message = "Position out of bounds. Try again."
        elsif board[row][col] != 0
            message = "Position occupied. Try again."
        else
            return [row, col], ""
        end
    end
end

def check_win(board, row, col)
    player = board[row][col]
    
    # Check row
    return true if board[row].all? { |cell| cell == player }
    
    # Check column
    return true if board.all? { |r| r[col] == player }
    
    # Check diagonals
    if row == col
        return true if (0..2).all? { |i| board[i][i] == player }
    end
    
    if row + col == 2
        return true if (0..2).all? { |i| board[i][2 - i] == player }
    end
    
    false
end

# Game loop
game_ended = false
until game_ended
    move, message = get_player_move(board, current_player, message)
    row, col = move
    board[row][col] = current_player
    
    if check_win(board, row, col)
        winner = current_player == 1 ? 'X' : 'O'
        message = "Player #{winner} wins!"
        print_board(board, message)
        game_ended = true
    elsif is_board_filled(board)
        message = "It's a draw!"
        print_board(board, message)
        game_ended = true
    else
        current_player = 3 - current_player  # Switch player
        message = ""
    end
end