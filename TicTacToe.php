<?php
$board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
$message = "";

# Current player: 1 for 'X', 2 for 'O'.
$curr_player = 1;

function is_board_filled(): bool
{
    global $board;
    for ($i = 0; $i < 3; $i++) {
        for ($j = 0; $j < 3; $j++) {
            if ($board[$i][$j] == 0) return false;
        }
    }
    return true;
}

function print_board(): void
{
    global $board, $message;
    print "\033[H\033[2J";
    print "\n  0 1 2\n";
    for ($row = 0; $row < 3; $row++) {
        print "$row ";
        for ($col = 0; $col < 3; $col++) {
            $symbol = $board[$row][$col] == 1 ? 'X' : ($board[$row][$col] == 2 ? 'O' : '.');
            print "$symbol ";
        }
        print "\n";
    }
    print "$message\n";
}

function get_player_move(): array
{
    global $board, $message, $curr_player;
    while (true) {
        print_board();
        $prompt = sprintf(
            "Player %s's turn. Enter row and column (0-2): ",
            $curr_player == 1 ? "X" : "O"
        );

        $input = trim(readline($prompt));
        $tokens = preg_split('/\s+/', $input);

        if (count($tokens) < 2) {
            $message = "Invalid input. Enter two numbers separated by space.";
            continue;
        }

        if (!ctype_digit($tokens[0]) || !ctype_digit($tokens[1])) {
            $message = "Invalid numbers. Try again.";
            continue;
        }

        $row = (int)$tokens[0];
        $col = (int)$tokens[1];

        if ($row < 0 || $row > 2 || $col < 0 || $col > 2) {
            $message = "Position out of bounds. Try again.";
        } elseif ($board[$row][$col] != 0) {
            $message = "Position occupied. Try again.";
        } else {
            $message = "";
            return [$row, $col];
        }
    }
}

function check_win(int $row, int $col): bool
{
    global $board;
    $player = $board[$row][$col];

    # Check row
    if ($board[$row][0] == $player && $board[$row][1] == $player && $board[$row][2] == $player)
        return true;

    # Check column
    if ($board[0][$col] == $player && $board[1][$col] == $player && $board[2][$col] == $player)
        return true;

    # Check main diagonal
    if ($row == $col && $board[0][0] == $player && $board[1][1] == $player && $board[2][2] == $player)
        return true;

    # Check anti-diagonal
    if ($row + $col == 2 && $board[0][2] == $player && $board[1][1] == $player && $board[2][0] == $player)
        return true;

    return false;
}

# on start:
$game_ended = 0;

while (!$game_ended) {
    $player_move = get_player_move();
    $row = $player_move[0];
    $col = $player_move[1];
    $board[$row][$col] = $curr_player;

    if (check_win($row, $col)) {
        $winner = $curr_player == 1 ? 'X' : 'O';
        $message = sprintf("Player '%s' wins!", $winner);
        print_board();
        $game_ended = 1;
    } elseif (is_board_filled()) {
        $message = "It's a draw!";
        print_board();
        $game_ended = 1;
    } else {
        $curr_player = 3 - $curr_player;    # Switch player (1->2, 2->1)
    }
}
print "\n";
