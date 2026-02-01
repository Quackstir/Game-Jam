class_name MaskCopProjectile
extends Area2D

var Direction : Vector2 = Vector2.DOWN
@export var Speed : float = 400

@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	position += Direction * Speed * delta
