# https://www.youtube.com/watch?v=m7aFAAfMXuk - Used for the initial setup of the game
# with some modifications

extends Node2D

@onready var buttons = $GridContainer.get_children()

#Game States
var currentPlayer
var board

func _ready() -> void:
	var index = 0
	for button in buttons:
		button.connect("pressed", onClick.bind(index, button))
		index+=1

func onClick(index, button):
	board[index / 3][index % 3] = currentPlayer
	button.text = currentPlayer
	button.disabled = true
	if checkWin() or checkFull():
		if checkFull():
			$Menu/Label.text = "DRAW"
		else:
			$Menu/Label.text = currentPlayer + "'s Win"
		$Menu.show()
	currentPlayer = "X" if currentPlayer == "O" else "O"

func checkWin():
	for i in range(3):
		if board[i][0] == board[i][1] and  board[i][1] == board[i][2] and board[i][2] != "":
			return true
		if board[0][i] == board[1][i] and  board[1][i] == board[2][i] and board[2][i] != "":
			return true
	if board[0][0] == board[1][1] and board[1][1] == board[2][2] and board[2][2] != "":
		return true
	if board[2][0] == board[1][1] and board[1][1] == board[0][2] and board[0][2] != "":
		return true
	return false

func checkFull():
	for row in range(3):
		for col in range(3):
			if board[row][col] == "":
				return false
	return true

func resetGame():
	currentPlayer = "X"
	board = [["", "", ""], ["", "", ""], ["", "", ""]]
	for button in buttons:
		button.text = ""
		button.disabled = false
	$Menu.hide()
