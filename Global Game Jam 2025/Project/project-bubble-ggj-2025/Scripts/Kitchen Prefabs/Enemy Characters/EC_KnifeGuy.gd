extends Node2D

@onready var knife_anchor: Node2D = $"Knife Anchor"
@export var KnifeSpeed:float = 1

func _physics_process(delta: float) -> void:
	knife_anchor.rotation += delta * -KnifeSpeed
