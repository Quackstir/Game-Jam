class_name GameManager
extends Node

var score:int = 0:
	set(newValue):
		score = newValue
		score_change.emit(score)

signal score_change(new_score:int)
