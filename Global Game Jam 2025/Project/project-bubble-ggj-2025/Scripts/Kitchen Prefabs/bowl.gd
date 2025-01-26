extends StaticBody2D

@onready var bowl_collision_polygon_2d = $BowlCollisionPolygon2D
@onready var bowl_polygon_2d = $BowlCollisionPolygon2D/BowlPolygon2D

func _ready() -> void:
	bowl_polygon_2d.polygon = bowl_collision_polygon_2d.polygon
