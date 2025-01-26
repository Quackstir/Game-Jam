extends Camera2D
@export var camera_path : Array[camera_dock]

@export var TRANSITION_SPEED = 0.6
var _current_dock = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not camera_path.is_empty():
		position = camera_path[_current_dock].position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_bubble_character_player_reached_screen_edge() -> void:
	_current_dock += 1
	if camera_path[_current_dock]:
		var tween = create_tween()
		tween.tween_property($".", "position", camera_path[_current_dock].position, TRANSITION_SPEED)
