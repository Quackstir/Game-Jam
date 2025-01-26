extends StaticBody2D

@onready var knife_collision_polygon_2d = $KnifeCollisionPolygon2D
@onready var knife_polygon_2d = $KnifeCollisionPolygon2D/KnifePolygon2D

func _ready() -> void:
	knife_polygon_2d.polygon = knife_collision_polygon_2d.polygon
