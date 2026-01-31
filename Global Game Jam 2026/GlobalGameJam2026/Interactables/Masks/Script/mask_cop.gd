class_name MaskCop
extends Mask

@export var cop_projectile:PackedScene

func _init() -> void:
	can_use = true


func on_interact(player:PlayerController) -> void:
	super(player)


func activate_mask() -> void:
	if !can_use:
		return
	can_use = false
	_create_projectile()
	print("shooty mc shoot shoot")


func _create_projectile() -> void:
	var newProjectile:MaskCopProjectile = cop_projectile.instantiate()
	newProjectile.global_position = global_position
	newProjectile.rotation = global_rotation
	newProjectile.Direction = newProjectile.transform.x
	get_tree().get_root().add_child(newProjectile)
