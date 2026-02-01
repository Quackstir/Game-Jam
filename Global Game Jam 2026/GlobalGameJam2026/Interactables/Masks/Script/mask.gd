class_name Mask
extends Interactable

@export var can_activate : bool = true
var can_use : bool :
	set(newValue):
		can_use = newValue
		update_use.emit(can_use)
var _player : PlayerController

signal update_use(can_use)

func on_interact(player:PlayerController) -> void:
	super(player)
	reparent(player)
	position = Vector2.ZERO
	monitorable = false
	_player = player


func remove_mask(player:PlayerController) -> void:
	print("Removing mask")
	reparent(get_tree().current_scene)
	position = player.position
	monitorable = true
	_player = null


func activate_mask() -> void:
	if !can_use:
		return
