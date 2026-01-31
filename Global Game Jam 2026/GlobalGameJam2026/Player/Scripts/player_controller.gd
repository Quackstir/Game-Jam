class_name PlayerController
extends CharacterBody2D

@export var movement_speed:float = 200
var _movement_input:Vector2

var _current_interactable:Interactable
var _current_mask:Mask


func _input(event: InputEvent) -> void:
	_handle_movement()

	if event.is_action_pressed("interact"):
		_handle_interact()
	
	if event.is_action_pressed("activate_mask"):
		_handle_mask_activate()


func _handle_movement() -> void:
	var _horizontal_movement:float = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	var _vertical_movement:float = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	_movement_input = Vector2(_horizontal_movement,_vertical_movement)


func _physics_process(delta: float) -> void:
	velocity = _movement_input * movement_speed * delta
	move_and_slide()


func _handle_interact() -> void:
	if _current_interactable == null:
		print("nothing")
		return
		
	if _current_interactable is Mask:
		_handle_wear_mask()
		return
		
	print("interacting")
	_current_interactable.on_interact(self)


func _handle_wear_mask() -> void:
	if _current_mask == null:
		_current_interactable.on_interact(self)
		_current_mask = _current_interactable
		return
	
	_current_mask.remove_mask(self)
	_current_mask = null
	_current_interactable.on_interact(self)
	_current_mask = _current_interactable


func _on_detect_interactables_area_entered(area: Area2D) -> void:
	if area is Interactable:
		_current_interactable = area


func _on_detect_interactables_area_exited(area: Area2D) -> void:
	if area != null:
		_current_interactable = null


func _handle_mask_activate() -> void:
	if _current_mask == null: 
		return

	print("activate mask")
	_current_mask.activate_mask()
