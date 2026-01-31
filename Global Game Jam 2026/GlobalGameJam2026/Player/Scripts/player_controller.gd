class_name PlayerController
extends CharacterBody2D

@export var movement_speed : float = 200
var _movement_input : Vector2

var _current_interactable : Interactable
var _current_mask : Mask

var is_detectable : bool:
	set(newValue):
		is_detectable = newValue
		sprite_2d.visible = is_detectable

@onready var sprite_2d : Sprite2D = $Sprite2D

signal on_movement(is_moving)

func _input(event: InputEvent) -> void:
	#Yes I am aware that there are multiple solutions for this one of them being
	# Finite State Machine which I could copy and paste code but lazy
	if event.is_action("move_down") or \
			event.is_action("move_left") or \
			event.is_action("move_right") or \
			event.is_action("move_up"):
		_handle_movement()
		look_at(_movement_input + global_position)

	if event.is_action_pressed("interact"):
		_handle_interact()
	
	if event.is_action_pressed("activate_mask"):
		_handle_mask_activate()


func _handle_movement() -> void:
	var _horizontal_movement:float = Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left")
	var _vertical_movement:float = Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	_movement_input = Vector2(_horizontal_movement,_vertical_movement)
	
	var _total_movement:float = _movement_input.x + _movement_input.y
	var _is_moving:bool = _total_movement != 0
	on_movement.emit(_is_moving)


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
	if area is not Interactable:
		return
		
	var _interactable : Interactable = area as Interactable
	
	if _interactable.can_interact:
		_current_interactable = area
	else:
		_interactable.activate()
	


func _on_detect_interactables_area_exited(area: Area2D) -> void:
	if area != null:
		_current_interactable = null


func _handle_mask_activate() -> void:
	if _current_mask == null: 
		return

	print("activate mask")
	_current_mask.activate_mask()
