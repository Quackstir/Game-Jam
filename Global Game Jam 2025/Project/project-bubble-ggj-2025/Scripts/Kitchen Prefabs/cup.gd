extends StaticBody2D

@onready var cup_collision_polygon_2d = $CupCollisionPolygon2D
@onready var cup_polygon_2d = $CupCollisionPolygon2D/CupPolygon2D

func _ready() -> void:
	cup_polygon_2d.polygon = cup_collision_polygon_2d.polygon
