extends StaticBody2D

@onready var counter_collision_polygon_2d = $CounterCollisionPolygon2D
@onready var counter_polygon_2d = $CounterCollisionPolygon2D/CounterPolygon2D

func _ready() -> void:
	counter_polygon_2d.polygon = counter_collision_polygon_2d.polygon
