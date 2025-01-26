class_name VictoryActivate
extends Node

@export var UI_VictoryScreen:PackedScene
@onready var player: bubble_character = $".."

func _on_victory_detector_area_entered(area: Area2D) -> void:
	var victoryScreenRef = UI_VictoryScreen.instantiate()
	get_tree().current_scene.add_child(victoryScreenRef)
	player.process_mode = Node.PROCESS_MODE_DISABLED
