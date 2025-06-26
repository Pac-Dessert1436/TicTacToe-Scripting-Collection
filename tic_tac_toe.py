import pygame

# Constants
WIDTH, HEIGHT = 300, 300
LINE_WIDTH = 10
BOARD_ROWS, BOARD_COLS = 3, 3
SQUARE_SIZE = WIDTH // BOARD_COLS
CIRCLE_RADIUS = SQUARE_SIZE // 3
CIRCLE_WIDTH = 15
X_WIDTH = 25
SPACE = SQUARE_SIZE // 4

# Colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
RED = (255, 0, 0)
BLUE = (0, 0, 255)
CYAN = (0, 255, 255)
GRAY = (100, 100, 100)

# Initialize Pygame
pygame.init()
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Tic-Tac-Toe")
board = [[0] * BOARD_COLS for _ in range(BOARD_ROWS)]
curr_player = 1  # 1 for X, 2 for O
message = ""


def draw_symbol(is_symbol_x: bool, color: tuple, row: int, col: int) -> None:
    if is_symbol_x:
        pygame.draw.line(screen, color,
                         (col * SQUARE_SIZE + SPACE, row *
                          SQUARE_SIZE + SQUARE_SIZE - SPACE),
                         (col * SQUARE_SIZE + SQUARE_SIZE -
                          SPACE, row * SQUARE_SIZE + SPACE),
                         X_WIDTH)
        pygame.draw.line(screen, color,
                         (col * SQUARE_SIZE + SPACE,
                          row * SQUARE_SIZE + SPACE),
                         (col * SQUARE_SIZE + SQUARE_SIZE - SPACE,
                          row * SQUARE_SIZE + SQUARE_SIZE - SPACE),
                         X_WIDTH)
    else:
        pygame.draw.circle(screen, color,
                           (col * SQUARE_SIZE + SQUARE_SIZE // 2,
                            row * SQUARE_SIZE + SQUARE_SIZE // 2),
                           CIRCLE_RADIUS, CIRCLE_WIDTH)


def draw_board() -> None:
    screen.fill(WHITE)
    for row in range(1, BOARD_ROWS):
        pygame.draw.line(screen, CYAN, (0, row * SQUARE_SIZE),
                         (WIDTH, row * SQUARE_SIZE), LINE_WIDTH)
    for col in range(1, BOARD_COLS):
        pygame.draw.line(screen, CYAN, (col * SQUARE_SIZE, 0),
                         (col * SQUARE_SIZE, HEIGHT), LINE_WIDTH)

    for row in range(BOARD_ROWS):
        for col in range(BOARD_COLS):
            if board[row][col] == 1:
                draw_symbol(True, RED, row, col)
            elif board[row][col] == 2:
                draw_symbol(False, BLUE, row, col)

    if message:
        font = pygame.font.Font(None, 36)
        upper_text = font.render(message, True, BLACK)
        lower_text = font.render("Press \"R\" to restart.", True, BLACK)
        screen.blit(upper_text, (WIDTH // 2 -
                    upper_text.get_width() // 2, SQUARE_SIZE - 15))
        screen.blit(lower_text, (WIDTH // 2 -
                    lower_text.get_width() // 2, SQUARE_SIZE * 2 - 15))
    
    # Draw hover preview if game is active and cell is empty
    if not message:
        mouse_x, mouse_y = pygame.mouse.get_pos()
        hover_row = mouse_y // SQUARE_SIZE
        hover_col = mouse_x // SQUARE_SIZE
        
        # Only show preview if cell is empty and within bounds
        if (0 <= hover_row < BOARD_ROWS and 
            0 <= hover_col < BOARD_COLS and 
            board[hover_row][hover_col] == 0):
            
            # Draw current player's symbol in dark gray
            draw_symbol(curr_player == 1, GRAY, hover_row, hover_col)

    pygame.display.update()


def check_win(row: int, col: int) -> bool:
    player = board[row][col]

    # Check row
    if all(board[row][c] == player for c in range(BOARD_COLS)):
        return True

    # Check column
    if all(board[r][col] == player for r in range(BOARD_ROWS)):
        return True

    # Check main diagonal
    if row == col and all(board[i][i] == player for i in range(BOARD_ROWS)):
        return True
    
    # Check anti-diagonal
    if row + col == 2 and all(board[i][2 - i] == player for i in range(BOARD_ROWS)):
        return True

    return False


def is_board_filled() -> bool:
    for i in range(3):
        for j in range(3):
            if board[i][j] == 0:
                return False
    return True


if __name__ == "__main__":
    draw_board()
    game_ended = False
    running = True

    while running:
        for event in pygame.event.get():
            match event.type:
                case pygame.QUIT:
                    running = False
                case pygame.MOUSEBUTTONDOWN if not game_ended:
                    mouse_x, mouse_y = event.pos

                    row: int = mouse_y // SQUARE_SIZE
                    col: int = mouse_x // SQUARE_SIZE

                    if board[row][col] == 0:
                        board[row][col] = curr_player

                        if check_win(row, col):
                            winner = "X" if curr_player == 1 else "O"
                            message = f"Player {winner} wins!"
                            game_ended = True
                        elif is_board_filled():
                            message = "It's a draw!"
                            game_ended = True
                        else:
                            curr_player = 3 - curr_player  # Switch player
                case pygame.KEYDOWN if event.key == pygame.K_r:
                    board[:] = [[0] * BOARD_COLS for _ in range(BOARD_ROWS)]
                    curr_player = 1
                    message = ""
                    game_ended = False

        draw_board()

    pygame.quit()
