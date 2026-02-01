class_name PlayerController
extends CharacterBody2D

@export var movement_speed : float = 200
var _movement_input : Vector2

var _current_interactable : Interactable:
	set(newValue):
		_current_interactable = newValue
		keyboard_e.visible = _current_interactable != null
var _current_mask : Mask :
	set(newValue):
		_current_mask = newValue
		equip_mask.emit(_current_mask)

var is_detectable : bool = true:
	set(newValue):
		is_detectable = newValue
		sprite_2d.visible = is_detectable

var can_move : bool = true :
	set(newValue):
		can_move = newValue
		if !can_move:
			velocity = Vector2(0,0)

@onready var pa_collider: CollisionShape2D = $PlayerAttack/PACollider
@onready var timer: Timer = $Timer

@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var keyboard_e: Sprite2D = $Node/Node2D/KeyboardE

@onready var interact_sfx: AudioStreamPlayer = $InteractSfx
@onready var small_loot_sfx: AudioStreamPlayer = $SmallLootSfx

signal on_movement(is_moving)
signal equip_mask(mask:Mask)
signal upequip_mask(mask:Mask)

func _input(event: InputEvent) -> void:
	if !can_move:
		return
	
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
	_movement_input = Vector2(_horizontal_movement,_vertical_movement).normalized()
	
	var _total_movement:float = _movement_input.x + _movement_input.y
	var _is_moving:bool = _total_movement != 0
	on_movement.emit(_is_moving)


func _physics_process(delta: float) -> void:
	velocity = _movement_input * movement_speed
	move_and_slide()


func _handle_interact() -> void:
	pa_collider.disabled = false
	timer.start()
	if _current_interactable == null:
		print("nothing")
		return
	
	interact_sfx.play()
	
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
	upequip_mask.emit(_current_mask)
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
		small_loot_sfx.play()


func _on_detect_interactables_area_exited(area: Area2D) -> void:
	if area != null:
		_current_interactable = null


func _handle_mask_activate() -> void:
	if _current_mask == null: 
		return

	print("activate mask")
	_current_mask.activate_mask()


func _on_detect_back_area_entered(area: Area2D) -> void:
	print("Stab em in the back")
	keyboard_e.visible = true


func _on_detect_back_area_exited(area: Area2D) -> void:
	keyboard_e.visible = false


func _on_timer_timeout() -> void:
	pa_collider.disabled = true
