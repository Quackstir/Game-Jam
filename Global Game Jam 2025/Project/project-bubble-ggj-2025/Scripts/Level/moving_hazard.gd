extends Node2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

const SPEED = 0.1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_follow_2d.progress_ratio += delta * SPEED
