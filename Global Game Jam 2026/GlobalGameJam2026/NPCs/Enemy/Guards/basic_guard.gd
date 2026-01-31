class_name BasicGuard
extends BasicEnemy

enum State{
	IDLE,
	PATROL,
	PATROL_LOOK,
	PATROL_TURN,
	CHASE,
	SEARCH,
	RESET,
}

enum Dir{
	NONE = -1,
	UP,
	LEFT,
	RIGHT,
	DOWN,
}

const PATROL_SPEED = 150
const CHASE_SPEED = 180
const TURN_SPEED = 5.0

@export var current_dir: Dir = Dir.NONE
@export var patrol_path: Path2D
@export var path_follow: PathFollow2D

var _current_state: State
var _player_location: Vector2 # Last known player location
var _target_nav_goal: Vector2
var _waypoint: Area2D
var _next_waypoint_index: int
var _current_speed: int

# local static variables
var _turn_progress: float
var _old_rotation: float
var _goal_rotation: float
var _turn_values_set: bool

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	_current_state = State.PATROL
	_player_location = Vector2.ZERO
	_target_nav_goal = Vector2.ZERO
	_init_waypoint()
	_current_speed = PATROL_SPEED
	_turn_values_set = false


func _process(delta):
	_parent_waypoint_once()
	match _current_state:
		State.PATROL:
			_patrol(delta)
		State.PATROL_TURN:
			_turn_on_patrol(delta)


func _physics_process(delta):
	if _current_state != State.CHASE:
		pass
	navigation_agent.target_position = _target_nav_goal
	var next_nav_position = navigation_agent.get_next_path_position()
	var new_velocity = (global_position.direction_to(next_nav_position)
			* CHASE_SPEED * delta)
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity_forced(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	move_and_slide()


func _init_waypoint():
	_waypoint = find_child("WaypointArea")
	_next_waypoint_index = 1
	_waypoint.position = patrol_path.curve.get_point_position(_next_waypoint_index)
	self.remove_child(_waypoint)


func _parent_waypoint_once():
	if not _waypoint.get_parent():
		Global.scene_manager.get_current_level().add_child(_waypoint)


func _patrol(delta):
	path_follow.progress += _current_speed * delta


func _turn_on_patrol(delta):
	# set static local variables 
	if not _turn_values_set:
		_turn_progress = 0.0
		_old_rotation = global_rotation
		_goal_rotation = get_angle_to(_waypoint.global_position) + global_rotation
		_turn_values_set = true
	
	# lerp rotation
	global_rotation = lerp_angle(_old_rotation, _goal_rotation, _turn_progress)
	_turn_progress += TURN_SPEED * delta
	_turn_progress = clampf(_turn_progress, 0.0, 1.0)
	
	# reset values when completed
	if is_equal_approx(fposmod(global_rotation, TAU), fposmod(_goal_rotation, TAU)):
		_turn_values_set = false
		_change_state(State.PATROL)


func _change_state(new_state):
	_current_state = new_state


# called when patrol checkpoint reached
func _on_waypoint_finder_area_entered(area):
	if (area != _waypoint):
		pass
	_move_waypoint()
	_change_state(State.PATROL_TURN)


func _move_waypoint():
	_next_waypoint_index += 1
	if _next_waypoint_index >= patrol_path.curve.point_count:
		_next_waypoint_index = 1
	_waypoint.position = patrol_path.curve.get_point_position(_next_waypoint_index)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_detection_area_area_entered(area):
	_on_player_spotted(area)


func _on_vision_cone_area_entered(area):
	_on_player_spotted(area)


func _on_player_spotted(_area):
	print("PLAYER SPOTTED!")
	_change_state(State.CHASE)
