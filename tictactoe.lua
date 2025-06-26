local board = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
local message = ""
local curr_player = 1  -- 1 for X, 2 for O

local function is_board_filled()
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == 0 then return false end
        end
    end
    return true
end

local function print_board()
    print("\x1b[H\x1b[2J")
    print("\n  0 1 2")
    for i = 1, 3 do
        io.write(i - 1 .. " ")
        for j = 1, 3 do
            local cell = board[i][j]
            local symbol = "."
            if cell == 1 then
                symbol = "X"
            elseif cell == 2 then
                symbol = "O"
            end
            io.write(symbol .. " ")
        end
        print()
    end
    print(message)
end

local function get_player_move()
    while true do
        print_board()
        io.write(string.format("Player %s's turn. Enter row and column (0-2): ",
                curr_player == 1 and "X" or "O"))
        
        local input = io.read("*l")
        local row, col = input:match("(%d)%s(%d)")
        
        if not row or not col then
            message = "Invalid input. Enter two numbers."
        else
            row = tonumber(row) + 1  -- Lua arrays are 1-based
            col = tonumber(col) + 1
            
            if row < 1 or row > 3 or col < 1 or col > 3 then
                message = "Position out of bounds. Try again."
            elseif board[row][col] ~= 0 then
                message = "Position occupied. Try again."
            else
                message = ""
                return row, col
            end
        end
    end
end

local function check_win(row, col)
    local player = board[row][col]
    
    -- Check row
    if board[row][1] == player and board[row][2] == player and board[row][3] == player then
        return true
    end
    
    -- Check column
    if board[1][col] == player and board[2][col] == player and board[3][col] == player then
        return true
    end
    
    -- Check diagonals
    if row == col then
        if board[1][1] == player and board[2][2] == player and board[3][3] == player then
        return true
        end
    end
    
    if row + col == 4 then  -- Because 1-based: (1,3)=4, (2,2)=4, (3,1)=4
        if board[1][3] == player and board[2][2] == player and board[3][1] == player then
        return true
        end
    end
    
    return false
end

-- Game loop
local game_ended = false
while not game_ended do
    local row, col = get_player_move()
    board[row][col] = curr_player
    
    if check_win(row, col) then
        local winner = curr_player == 1 and "X" or "O"
        message = string.format("Player '%s' wins!", winner)
        print_board()
        game_ended = true
    elseif is_board_filled() then
        message = "It's a draw!"
        print_board()
        game_ended = true
    else
        curr_player = 3 - curr_player  -- Switch player
    end
end