class_name BasicGuard
extends BasicEnemy

enum State{
	IDLE,
	PATROL,
	PATROL_LOOK,
	PATROL_TURN,
	CHASE,
	SEARCH,
	RESET_TURN,
	RESET,
	KNOCKED_OUT,
}

const PATROL_SPEED = 100
const CHASE_SPEED = 150
const TURN_SPEED = 4.0
const SEARCH_SPEED = 2.0
const IDLE_TIME = 0.3

@export var patrol_path: Path2D
@export var path_follow: PathFollow2D
@export var mask_to_drop: PackedScene

var _current_state: State
var _spotted_player: PlayerController
var _target_nav_goal: Vector2
var _waypoint: Area2D
var _next_waypoint_index: int
var _current_speed: int

# local static variables for _turn_on_patrol
var _turn_progress: float
var _old_rotation: float
var _goal_rotation: float
var _turn_values_set: bool
# local static variables for _flash_away_once
var _dead: bool
# local static variables for _look_around
var _look_values_set: bool
var _done_looking_left: bool
var _done_looking_right: bool

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var player_spotted_sfx: AudioStreamPlayer = $PlayerDetectedSfx

func _ready():
	_current_state = State.PATROL
	_spotted_player = null
	_target_nav_goal = Vector2.ZERO
	_init_waypoint()
	_current_speed = PATROL_SPEED
	_turn_values_set = false
	_dead = false
	_look_values_set = false
	_done_looking_left = false
	_done_looking_right = false
	set_physics_process(true)


func _process(delta):
	_parent_waypoint_once()
	match _current_state:
		State.PATROL:
			_patrol(delta)
		State.PATROL_TURN:
			_turn_on_patrol(delta)
		State.CHASE:
			look_at(_target_nav_goal)
		State.SEARCH:
			_look_around(delta)
		State.RESET_TURN:
			_turn_to_path(delta)
		State.RESET:
			look_at(_target_nav_goal)
		State.KNOCKED_OUT:
			_flash_away_once()


func _physics_process(delta):
	match _current_state:
		State.CHASE:
			# update player location
			if _spotted_player:
				_target_nav_goal = _spotted_player.global_position
			_nav_to_target(delta, CHASE_SPEED)
		State.RESET:
			_nav_to_target(delta, PATROL_SPEED)
		_:
			return
	_check_target_reached()
	move_and_slide()


# End chase if target has been reached
func _check_target_reached():
	if navigation_agent.is_navigation_finished():
		_on_navigation_agent_2d_velocity_computed(Vector2.ZERO)
		# check if ended chasing or ending returning to patrol
		match _current_state:
			State.CHASE:
				_change_state(State.SEARCH)
			State.RESET:
				_resume_patrol()


func _head_back_to_patrol_path():
	_change_state(State.RESET)
	var local_path_position = patrol_path.to_local(global_position)
	_target_nav_goal = patrol_path.curve.get_closest_point(local_path_position)
	


func _resume_patrol():
	_change_state(State.PATROL)
	# find and set new progress on path
	var local_point = patrol_path.to_local(global_position)
	var offset = patrol_path.curve.get_closest_offset(local_point)
	path_follow.progress = offset
	# return guard to parent's coordinates
	self.position = Vector2.ZERO
	# find and set next waypoint
	_next_waypoint_index = _find_next_checkpoint()
	_waypoint.position = patrol_path.curve.get_point_position(_next_waypoint_index)
	look_at(_waypoint.global_position)


func _find_next_checkpoint() -> int:
	# iterate thru checkpoints on path
	for i in range(patrol_path.curve.point_count):
		var checkpoint = patrol_path.curve.get_point_position(i)
		var progress = patrol_path.curve.get_closest_offset(checkpoint)
		# return the first checkpoint beyond our current progress
		if path_follow.progress < progress:
			return i
	# otherwise return first checkpoint
	return 0


# chase player
func _nav_to_target(_delta, speed):
	navigation_agent.target_position = _target_nav_goal
	var next_nav_position = navigation_agent.get_next_path_position()
	var new_velocity = (global_position.direction_to(next_nav_position)
			* speed)
	
	#if navigation_agent.avoidance_enabled:
		#navigation_agent.set_velocity_forced(new_velocity)
	#else:
	_on_navigation_agent_2d_velocity_computed(new_velocity)


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


# turns guard to face next patrol _waypoint
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


# Plays after losing track of player
func _look_around(delta):
	# idle time
	await get_tree().create_timer(IDLE_TIME).timeout
	
	# set static local variables
	if not _look_values_set:
		_turn_progress = 0.0
		_old_rotation = global_rotation
		_done_looking_left = false
		_done_looking_right = false
		_look_values_set = true
	
	var goal: float
	
	# look left
	if not _done_looking_left:
		goal = _old_rotation - deg_to_rad(45.0)
	elif not _done_looking_right:
		# look right
		goal = _old_rotation + deg_to_rad(90.0)
	else:
		# return to original
		goal = _old_rotation - deg_to_rad(45.0)
	
	_lerp_rotation(goal, delta)
	
	# when done move on to next step
	if is_equal_approx(fposmod(global_rotation, TAU), fposmod(goal, TAU)):
		if not _done_looking_left:
			_done_looking_left = true
			_old_rotation = goal
			_turn_progress = 0.0
		elif not _done_looking_right:
			_done_looking_right = true
			_old_rotation = goal
			_turn_progress = 0.0
		else:
			# idle time
			await get_tree().create_timer(IDLE_TIME).timeout
			_look_values_set = false
			var local_path_position = patrol_path.to_local(global_position)
			_target_nav_goal = patrol_path.curve.get_closest_point(local_path_position)
			_change_state(State.RESET_TURN)


func _lerp_rotation(end_rotation, delta):
	global_rotation = lerp_angle(_old_rotation, end_rotation, _turn_progress)
	_turn_progress += SEARCH_SPEED * delta
	_turn_progress = clampf(_turn_progress, 0.0, 1.0)


# lerps to look at path point then heads there RESET_TURN -> RESET
func _turn_to_path(delta):
	if _turn_towards(_target_nav_goal, delta):
		_head_back_to_patrol_path()


# returns true once turn is complete
func _turn_towards(point, delta) -> bool:
	# set static local variables 
	if not _turn_values_set:
		_turn_progress = 0.0
		_old_rotation = global_rotation
		_goal_rotation = get_angle_to(point) + global_rotation
		_turn_values_set = true
	
	# lerp rotation
	global_rotation = lerp_angle(_old_rotation, _goal_rotation, _turn_progress)
	_turn_progress += TURN_SPEED * delta
	_turn_progress = clampf(_turn_progress, 0.0, 1.0)
	
	# reset values when completed
	if is_equal_approx(fposmod(global_rotation, TAU), fposmod(_goal_rotation, TAU)):
		_turn_values_set = false
		return true
	return false


func _change_state(new_state):
	_current_state = new_state
	_turn_values_set = false
	_look_values_set = false


# called when patrol checkpoint reached
func _on_waypoint_finder_area_entered(area):
	if _current_state != State.PATROL or area != _waypoint:
		return
	_move_waypoint()
	_change_state(State.PATROL_TURN)


func _move_waypoint():
	_next_waypoint_index += 1
	if _next_waypoint_index >= patrol_path.curve.point_count:
		_next_waypoint_index = 1
	_waypoint.position = patrol_path.curve.get_point_position(_next_waypoint_index)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity


func _on_player_spotted(player):
	if player.is_detectable:
		if not _spotted_player and not player_spotted_sfx.playing:
			player_spotted_sfx.play()
		_spotted_player = player
		_target_nav_goal = _spotted_player.global_position
		_change_state(State.CHASE)


func _on_vision_cone_body_entered(body):
	if _current_state != State.KNOCKED_OUT:
		_on_player_spotted(body)


func _on_vision_cone_body_exited(_body):
	_spotted_player = null


func _on_detection_area_body_entered(body):
	if _current_state != State.KNOCKED_OUT:
		# Player captured!
		body.can_move = false
		body.is_detectable = false
		_change_state(State.IDLE)
		Global.scene_manager.change_hud_scene("res://Levels/LoseScreen/lose_screen.tscn")


# Knock out guard
func _on_blind_spot_area_entered(_area):
	_knock_out()


# get shot
func _on_hurt_box_area_entered(area):
	area.queue_free()
	_knock_out()


func _knock_out():
	_change_state(State.KNOCKED_OUT)


func _flash_away_once():
	if not _dead:
		_dead = true
		var i = 0
		# flash for a bit
		while i < 9:
			await get_tree().create_timer(0.3).timeout
			sprite.visible = not sprite.visible
			i += 1
		# destroy guard and leave behind mask
		_drop_mask_and_leave()


func _drop_mask_and_leave():
	var mask = mask_to_drop.instantiate()
	mask.global_position = self.global_position
	Global.scene_manager.get_current_level().add_child(mask)
	patrol_path.queue_free()


# FOR DEBUG
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		#_knock_out()
		pass
