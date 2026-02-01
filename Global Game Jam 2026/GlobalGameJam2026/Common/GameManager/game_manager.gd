class_name GameManager
extends Node

var score : int = 0:
	set(newValue):
		score = newValue
		score_change.emit(score)
		print(score)

signal score_change(new_score:int)

var can_win : bool = false:
	set(newValue):
		can_win = newValue
		win_state_change.emit(can_win)

signal win_state_change(state_change:bool)

func _ready() -> void:
	Global.game_manager = self
