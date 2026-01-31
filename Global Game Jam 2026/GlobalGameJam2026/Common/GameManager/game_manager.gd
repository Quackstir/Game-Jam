class_name GameManager
extends Node

var score : int = 0:
	set(newValue):
		score = newValue
		score_change.emit(score)
		print(score)

signal score_change(new_score:int)

var can_win : bool = false

func _ready() -> void:
	Global.game_manager = self
