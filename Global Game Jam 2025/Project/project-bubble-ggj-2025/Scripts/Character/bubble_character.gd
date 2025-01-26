extends CharacterBody2D
class_name bubble_character

var PlayerMovement = preload("res://Scripts/Character/player_movement_normal.gd").new()
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

# JUMP ABILITY
@export var JUMP_ABILITY_COOLDOWN = 7.0
signal player_jumped(jumps_left:int)
signal jump_restored(jumps_left:int)

# GROWTH VALUES
const GROWTH_SCALE = 1.2
const GROWTH_SPEED = 0.5
var growth_state = 1
signal player_grew(growth_state:int)

# CAMERA STUFF
signal player_reached_screen_edge

func _physics_process(delta: float) -> void:
	PlayerMovement.handle_input(self, delta)

func on_jump(jumps_left: int):
	get_tree().create_timer(JUMP_ABILITY_COOLDOWN).timeout.connect(_on_jump_ability_timer_end)
	player_jumped.emit(jumps_left)

func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	#TODO popping animation
	await transition_to_game_over()
	queue_free()

func _on_jump_ability_timer_end() -> void:
	jump_restored.emit(PlayerMovement.add_avaliable_jump())

func _on_growth_detector_area_entered(area: Area2D) -> void:
	if area.has_meta("type"):
		match area.get_meta("type"):
			"Growth":
				var scale_tween = create_tween()
				scale_tween.tween_property($".", "scale", scale * GROWTH_SCALE, GROWTH_SPEED)
				growth_state += 1
				player_grew.emit(growth_state)
			"Transition":
				player_reached_screen_edge.emit()
	area.queue_free()

func transition_to_game_over():
	#get_tree().paused = true
	LevelTransition.fade_to_black()
	death_sound.play()
	await death_sound.finished
	#get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/game_over_scene.tscn")
	LevelTransition.fade_from_black()
