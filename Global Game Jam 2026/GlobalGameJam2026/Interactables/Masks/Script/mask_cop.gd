class_name MaskCop
extends Mask

@export var cop_projectile:PackedScene
@export var projectile_art:Array[Texture2D]

@onready var shoot_mask_sfx: AudioStreamPlayer = $ShootMaskSfx

func _init() -> void:
	can_use = true


func on_interact(player:PlayerController) -> void:
	super(player)


func activate_mask() -> void:
	#if !can_use:
	#	return
	if projectile_art.size() <= 0:
		can_use = false
		return
	#can_use = false
	_create_projectile()
	print("shooty mc shoot shoot")
	shoot_mask_sfx.play()


func _create_projectile() -> void:
	var newProjectile:MaskCopProjectile = cop_projectile.instantiate()
	newProjectile.global_position = global_position
	newProjectile.rotation = global_rotation
	newProjectile.Direction = newProjectile.transform.x
	var art:int = randi_range(0, projectile_art.size() - 1)
	var proj:Texture2D = projectile_art.get(art)
	projectile_art.remove_at(art)
	get_tree().get_root().add_child(newProjectile)
	newProjectile.sprite_2d.texture = proj


func _on_shoot_mask_sfx_finished() -> void:
	if projectile_art.size() <= 0:
		queue_free()
