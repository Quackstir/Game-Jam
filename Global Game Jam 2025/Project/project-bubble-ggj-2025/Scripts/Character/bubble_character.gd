extends CharacterBody2D
class_name bubble_character

var PlayerMovement = preload("res://Scripts/Character/player_movement_normal.gd").new()

const JUMP_ABILITY_COOLDOWN = 4.0
signal player_jumped(jumps_left:int)

func _physics_process(delta: float) -> void:
	PlayerMovement.handle_input(self, delta)

func on_jump(jumps_left: int):
	get_tree().create_timer(JUMP_ABILITY_COOLDOWN).timeout.connect(_on_jump_ability_timer_end)
	player_jumped.emit(jumps_left)

func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	#TODO popping animation
	#TODO send signal for game over when player pops
	queue_free()

func _on_jump_ability_timer_end() -> void:
	PlayerMovement.add_avaliable_jump()
