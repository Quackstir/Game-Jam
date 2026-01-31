class_name BasicGuard
extends BasicEnemy

enum State{
	IDLE,
	PATROL,
	CHASE,
	SEARCH,
	RESET,
}

const PATROL_SPEED = 150
const CHASE_SPEED = 250

@export var patrol_path: Path2D
@export var path_follow: PathFollow2D

var _current_state: State
var _player_location: Vector2
var _patrol_points: PackedVector2Array
var _current_speed


func _ready():
	_current_state = State.PATROL
	_player_location = Vector2.ZERO
	if patrol_path:
		_patrol_points = patrol_path.curve.get_baked_points()
	_current_speed = PATROL_SPEED


func _process(delta):
	match _current_state:
		State.PATROL:
			path_follow.progress += _current_speed * delta
