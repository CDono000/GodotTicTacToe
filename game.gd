# https://www.youtube.com/watch?v=m7aFAAfMXuk - Used for the initial setup of the game
# with some modifications

extends Node2D

@onready var buttons = $GridContainer.get_children()

#Game States
var currentPlayer = "X"
var board
var AI = false

func _ready() -> void:
	var index = 0
	for button in buttons:
		button.connect("pressed", onClick.bind(index, button))
		index+=1

func onClick(index, button):
	place(index, button)
	if checkWin(board) == 0 and !checkFull(board) and AI:
		var bestMove = -1
		var bestScore = INF
		for AIIndex in range(9):
			if board[AIIndex/3][AIIndex%3] == "":
				board[AIIndex/3][AIIndex%3] = "O"
				var score = search(9, board.duplicate(true), true)
				board[AIIndex/3][AIIndex%3] = ""
				if score < bestScore:
					bestScore = score
					bestMove = AIIndex
		place(bestMove, buttons[bestMove])

func place(index, button):
	board[index / 3][index % 3] = currentPlayer
	button.text = currentPlayer
	button.disabled = true
	if checkWin(board) != 0 or checkFull(board):
		if checkWin(board) == 0 and checkFull(board):
			$Menu/Label.text = "DRAW"
		else:
			$Menu/Label.text = currentPlayer + "'s Win"
		$Menu.show()
	currentPlayer = "X" if currentPlayer == "O" else "O"

func checkWin(checkBoard: Array):
	var dict = {"X":1, "O":-1, "":0}
	for i in range(3):
		if checkBoard[i][0] == checkBoard[i][1] and  checkBoard[i][1] == checkBoard[i][2] and checkBoard[i][2] != "":
			return dict[checkBoard[i][2]]
		if checkBoard[0][i] == checkBoard[1][i] and  checkBoard[1][i] == checkBoard[2][i] and checkBoard[2][i] != "":
			return dict[checkBoard[2][i]]
	if checkBoard[0][0] == checkBoard[1][1] and checkBoard[1][1] == checkBoard[2][2] and checkBoard[2][2] != "":
		return dict[board[2][2]]
	if checkBoard[2][0] == checkBoard[1][1] and checkBoard[1][1] == checkBoard[0][2] and checkBoard[0][2] != "":
		return dict[checkBoard[0][2]]
	return 0

func checkFull(checkBoard):
	for row in range(3):
		for col in range(3):
			if checkBoard[row][col] == "":
				return false
	return true

func search(depth: int, searchBoard: Array, isMax: bool):
	var best
	if checkWin(searchBoard) != 0 or checkFull(searchBoard) or depth == 0:
		return evaluate(searchBoard)
	if isMax:
		best = -INF
		for index in range(9):
			if searchBoard[index/3][index%3] == "":
				searchBoard[index/3][index%3] = "X"
				var score = search(depth-1, searchBoard.duplicate(true), false)-10
				best = max(score, best)
	else:
		best = INF
		for index in range(9):
			if searchBoard[index/3][index%3] == "":
				searchBoard[index/3][index%3] = "X"
				var score = search(depth-1, searchBoard.duplicate(true), true)-10
				best = min(score, best)
	return best

func evaluate(evalBoard):
	var dict = {"X":1, "O":-1, "":0}
	var win = checkWin(evalBoard)
	var score = 0
	if win == -1:
		return -500
	elif win == 1:
		return 1000
	score += 7 * dict[board[0][0]]
	score += 7 * dict[board[2][0]]
	score += 7 * dict[board[2][2]]
	score += 7 * dict[board[0][2]]
	score += 5 * dict[board[1][1]]
	return score

func resetGame():
	board = [["", "", ""], ["", "", ""], ["", "", ""]]
	for button in buttons:
		button.text = ""
		button.disabled = false
	$Menu.hide()
	if currentPlayer == "O" and AI:
		var bestMove = -1
		var bestScore = INF
		for AIIndex in range(9):
			if board[AIIndex/3][AIIndex%3] == "":
				board[AIIndex/3][AIIndex%3] = "O"
				var score = search(9, board.duplicate(true), true)
				board[AIIndex/3][AIIndex%3] = ""
				if score < bestScore:
					bestScore = score
					bestMove = AIIndex
		place(bestMove, buttons[bestMove])

func _on_ai_pressed() -> void:
	AI = true
	resetGame()
