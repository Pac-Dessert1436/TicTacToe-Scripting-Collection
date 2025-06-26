use 5.32.1;
use strict;
use warnings;

my @board   = ( [ (0) x 3 ], [ (0) x 3 ], [ (0) x 3 ] );
my $message = "";

# Current player: 1 for 'X', 2 for 'O'.
my $curr_player = 1;

sub is_board_filled {
    foreach my $i ( 0 .. 2 ) {
        foreach my $j ( 0 .. 2 ) {
            return 0 unless $board[$i][$j];
        }
    }
    1;
}

sub print_board {
    print "\033[H\033[2J";
    print "\n  0 1 2\n";
    foreach my $row ( 0 .. 2 ) {
        print "$row ";
        foreach my $col ( 0 .. 2 ) {
            my $symbol =
                $board[$row][$col] == 1 ? 'X'
              : $board[$row][$col] == 2 ? 'O'
              :                           '.';
            print "$symbol ";
        }
        print "\n";
    }
    print "$message\n";
}

sub get_player_move {
    while (1) {
        print_board();
        print sprintf( "Player %s's turn. Enter row and column (0-2): ",
            $curr_player == 1 ? "X" : "O" );

        my $input = <STDIN>;
        chomp $input;
        my ( $row, $col ) = split ' ', $input;

        if ( $row < 0 || $row > 2 || $col < 0 || $col > 2 ) {
            $message = "Position out of bounds. Try again.";
        }
        elsif ( $board[$row][$col] != 0 ) {
            $message = "Position occupied. Try again.";
        }
        else {
            $message = "";
            return ( $row, $col );
        }
    }
}

sub check_win {
    my ( $row, $col ) = @_;
    my $player = $board[$row][$col];

    # Check row
    return 1
      if $board[$row][0] == $player
      && $board[$row][1] == $player
      && $board[$row][2] == $player;

    # Check column
    return 1
      if $board[0][$col] == $player
      && $board[1][$col] == $player
      && $board[2][$col] == $player;

    # Check main diagonal
    return 1
      if $row == $col
      && $board[0][0] == $player
      && $board[1][1] == $player
      && $board[2][2] == $player;
    
    # Check anti-diagonal
    return 1
      if $row + $col == 2
      && $board[0][2] == $player
      && $board[1][1] == $player
      && $board[2][0] == $player;

    0;
}

if ( $0 eq __FILE__ ) {
    my $game_ended = 0;

    while ( !$game_ended ) {
        my ( $row, $col ) = get_player_move();
        $board[$row][$col] = $curr_player;

        if ( check_win( $row, $col ) ) {
            my $winner = $curr_player == 1 ? 'X' : 'O';
            $message = sprintf( "Player \'%s\' wins!", $winner );
            print_board();
            $game_ended = 1;
        }
        elsif ( is_board_filled() ) {
            $message = "It's a draw!";
            print_board();
            $game_ended = 1;
        }
        else {
            $curr_player = 3 - $curr_player;    # Switch player (1->2, 2->1)
        }
    }
    print "\n";
}
