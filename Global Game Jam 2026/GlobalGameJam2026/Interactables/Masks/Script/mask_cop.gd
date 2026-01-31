class_name MaskCop
extends Mask

func _init() -> void:
	can_use = true


func on_interact(player:PlayerController) -> void:
	super(player)


func activate_mask() -> void:
	if !can_use:
		return
	can_use = false
	print("shooty mc shoot shoot")
