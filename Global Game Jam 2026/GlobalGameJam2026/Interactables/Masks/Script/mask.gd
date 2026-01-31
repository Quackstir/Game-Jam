class_name Mask
extends Interactable

var can_use:bool = true

func on_interact(player:PlayerController) -> void:
	super(player)
	reparent(player)
	position = Vector2.ZERO
	monitorable = false


func remove_mask(player:PlayerController) -> void:
	print("Removing mask")
	reparent(get_tree().current_scene)
	position = player.position
	monitorable = true


func activate_mask() -> void:
	if !can_use:
		return
