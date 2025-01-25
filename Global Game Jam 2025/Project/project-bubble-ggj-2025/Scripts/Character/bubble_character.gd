extends CharacterBody2D
class_name bubble_character

var PlayerMovement = preload("res://Scripts/Character/player_movement_normal.gd").new()

func _physics_process(delta: float) -> void:
	PlayerMovement.handle_input(self, delta)

func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	#TODO popping animation
	#TODO send signal for game over when player pops
	queue_free()
