extends StaticBody2D

@onready var fork_collision_polygon_2d = $ForkCollisionPolygon2D
@onready var fork_polygon_2d = $ForkCollisionPolygon2D/ForkPolygon2D

func _ready() -> void:
	fork_polygon_2d.polygon = fork_collision_polygon_2d.polygon
