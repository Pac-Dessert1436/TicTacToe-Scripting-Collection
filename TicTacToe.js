import readline from 'node:readline';

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

const board = Array.from({ length: 3 }, () => Array(3).fill(0));
let currPlayer = 1; // 1 for X, 2 for O
let message = "";

function isBoardFilled() {
    for (let i = 0; i < 3; i++)
        for (let j = 0; j < 3; j++)
            if (board[i][j] === 0)
                return false;
    return true;
}

function printBoard() {
    console.clear();
    console.log("\n  0 1 2");
    for (let row = 0; row < 3; row++) {
        let output = row + " ";
        for (let col = 0; col < 3; col++) {
            const symbol = board[row][col] === 1 ? 'X' : board[row][col] === 2 ? 'O' : '.';
            output += symbol + " ";
        }
        console.log(output);
    }
    console.log(message);
}

function getPlayerMove() {
    return new Promise((resolve) => {
        function askMove() {
            printBoard();
            const symbol = currPlayer === 1 ? 'X' : 'O';
            console.log(`Player ${symbol}'s turn. Enter row and column (0-2): `);
            rl.question('', (input) => {
                const [row, col] = input.split(' ').map(Number);
                if (row < 0 || row > 2 || col < 0 || col > 2) {
                    message = "Position out of bounds. Try again.";
                    askMove();
                } else if (board[row][col] !== 0) {
                    message = "Position occupied. Try again.";
                    askMove();
                } else {
                    message = "";
                    resolve([row, col]);
                }
            });
        }
        askMove();
    });
}

function checkWin(row, col) {
    const player = board[row][col];

    // Check row
    if (board[row][0] === player && board[row][1] === player && board[row][2] === player)
        return true;

    // Check column
    if (board[0][col] === player && board[1][col] === player && board[2][col] === player)
        return true;

    // Check main diagonal
    if (row === col && board[0][0] === player && board[1][1] === player && board[2][2] === player)
        return true;


    // Check anti-diagonal
    if (row + col === 2 && board[0][2] === player && board[1][1] === player && board[2][0] === player)
        return true;

    return false;
};


let gameEnded = false;

while (!gameEnded) {
    const [row, col] = await getPlayerMove();
    board[row][col] = currPlayer;

    if (checkWin(row, col)) {
        const winner = currPlayer === 1 ? "X" : "O";
        message = `Player "${winner}" wins!`;
        printBoard();
        gameEnded = true;
    } else if (isBoardFilled()) {
        message = "It's a draw!";
        printBoard();
        gameEnded = true;
    } else {
        currPlayer = 3 - currPlayer; // Switch player (1->2, 2->1)
    }
}
console.log();
rl.close();
