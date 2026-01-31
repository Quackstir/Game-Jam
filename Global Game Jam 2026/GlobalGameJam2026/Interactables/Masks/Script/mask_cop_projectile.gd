class_name MaskCopProjectile
extends Area2D

var Direction : Vector2 = Vector2.RIGHT
@export var Speed : float = 400

func _physics_process(delta: float) -> void:
	position += Direction * Speed * delta
