extends CharacterBody2D
class_name bubble_character

var PlayerMovement = preload("res://Scripts/Character/player_movement_normal.gd").new()

# JUMP ABILITY
const JUMP_ABILITY_COOLDOWN = 4.0
signal player_jumped(jumps_left:int)
signal jump_restored(jumps_left:int)

#GROWTH VALUES
const GROWTH_SCALE = 1.2
const GROWTH_SPEED = 0.5
var growth_state = 1
signal player_grew(growth_state:int)

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
	jump_restored.emit(PlayerMovement.add_avaliable_jump())

func _on_growth_detector_area_entered(area: Area2D) -> void:
	var scale_tween = create_tween()
	scale_tween.tween_property($".", "scale", scale * GROWTH_SCALE, GROWTH_SPEED)
	growth_state += 1
	_zoom_out_camera()
	player_grew.emit(growth_state)
	area.queue_free()

func _zoom_out_camera():
	var camera_tween = create_tween()
	camera_tween.tween_property($Camera2D, "zoom", Vector2(1/GROWTH_SCALE, 1/GROWTH_SCALE), GROWTH_SPEED)
