open System

let initialBoard: int list list = [ [ 0; 0; 0 ]; [ 0; 0; 0 ]; [ 0; 0; 0 ] ]

let printBoard (board: int list list) =
    printfn "\n  0 1 2"

    board
    |> List.iteri (fun (i: int) (row: int list) ->
        printf "%d " i

        row
        |> List.iter (fun (cell: int) ->
            let symbol =
                match cell with
                | 1 -> "X"
                | 2 -> "O"
                | _ -> "."

            printf "%s " symbol)

        printfn "")

let updateBoard (board: int list list) (row: int) (col: int) (value: int) =
    board
    |> List.mapi (fun (i: int) (r: int list) ->
        if i = row then
            r |> List.mapi (fun (j: int) (c: int) -> if j = col then value else c)
        else
            r)

let checkWin (board: int list list) (row: int) (col: int) (player: int) =
    // Check row
    let rowWin: bool =
        board |> List.item row |> List.forall (fun (x: int) -> x = player)

    // Check column
    let colWin: bool =
        board |> List.map (List.item col) |> List.forall (fun (x: int) -> x = player)

    // Check main diagonal (if move is on it)
    let diag1Win: bool =
        if row = col then
            [ 0; 1; 2 ]
            |> List.forall (fun (i: int) ->
                let r: int list = List.item i board
                List.item i r = player)
        else
            false

    // Check anti-diagonal (if move is on it)
    let diag2Win: bool =
        if row + col = 2 then
            [ 0; 1; 2 ]
            |> List.forall (fun (i: int) ->
                let r: int list = List.item i board
                List.item (2 - i) r = player)
        else
            false

    rowWin || colWin || diag1Win || diag2Win

let isBoardFull (board: int list seq) =
    board |> List.concat |> List.forall (fun (x: int) -> x <> 0)

let rec getPlayerMove (board: int list list) (currentPlayer: int) =
    printf "Player %s's turn. Enter row and column (0-2): " (if currentPlayer = 1 then "X" else "O")

    let input: string = Console.ReadLine().Trim()

    let tokens: string array =
        input.Split([| ' ' |], StringSplitOptions.RemoveEmptyEntries)

    match tokens with
    | [| rowStr: string; colStr: string |] ->
        match Int32.TryParse rowStr, Int32.TryParse colStr with
        | (true, row: int), (true, col: int) ->
            if row < 0 || row > 2 || col < 0 || col > 2 then
                printfn "Position out of bounds. Try again."
                getPlayerMove board currentPlayer
            elif List.item row board |> List.item col <> 0 then
                printfn "Position occupied. Try again."
                getPlayerMove board currentPlayer
            else
                row, col
        | _ ->
            printfn "Invalid numbers. Try again."
            getPlayerMove board currentPlayer
    | _ ->
        printfn "Invalid input. Please enter two numbers separated by space."
        getPlayerMove board currentPlayer

let rec gameLoop (board: int list list) (currentPlayer: int) =
    printBoard board
    let (row: int, col: int) = getPlayerMove board currentPlayer
    let newBoard: int list list = updateBoard board row col currentPlayer

    if checkWin newBoard row col currentPlayer then
        printBoard newBoard
        printfn "Player %s wins!" (if currentPlayer = 1 then "X" else "O")
    elif isBoardFull newBoard then
        printBoard newBoard
        printfn "It's a draw!"
    else
        gameLoop newBoard (3 - currentPlayer)

// on start:
gameLoop initialBoard 1
