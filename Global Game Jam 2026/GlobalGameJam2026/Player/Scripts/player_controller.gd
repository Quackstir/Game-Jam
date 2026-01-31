class_name PlayerController
extends CharacterBody2D

@export var movement_speed:float = 200
var _movement_input:Vector2

var _current_interactable:Interactable


func _input(event: InputEvent) -> void:
	_handle_movement()

	if event.is_action_pressed("interact"):
		_handle_interact()


func _handle_movement() -> void:
	var _horizontal_movement:float = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	var _vertical_movement:float = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	_movement_input = Vector2(_horizontal_movement,_vertical_movement)


func _physics_process(delta: float) -> void:
	velocity = _movement_input * movement_speed
	move_and_slide()


func _handle_interact() -> void:
	if _current_interactable != null:
		print("interacting")
		_current_interactable.on_interact()
	else:
		print("nothing")


func _on_detect_interactables_area_entered(area: Area2D) -> void:
	if area is Interactable:
		_current_interactable = area


func _on_detect_interactables_area_exited(area: Area2D) -> void:
	if area is Interactable:
		_current_interactable = null
