const SPEED = 150.0
const ACCELERATION = 1000.0
const FRICTION = 200.0

# JUMPING VALUES
const JUMP_VELOCITY = -260.0
const GRAVITY_SCALE = 0.2
const MAX_JUMPS = 3
var _avaliable_jumps = MAX_JUMPS
const JUMP_COOLDOWN = 1.0
var _jump_timer = 0.0

func add_avaliable_jump() -> int:
	_avaliable_jumps += 1
	if _avaliable_jumps > MAX_JUMPS:
		_avaliable_jumps = MAX_JUMPS
	return _avaliable_jumps

func handle_input(player: CharacterBody2D, delta: float) -> void:
	_apply_gravity(player,delta)
	_handle_jump(player, delta)
	_handle_horizontal_input(player,delta)
	player.move_and_slide()

func _apply_gravity(player: CharacterBody2D, delta: float):
	#if not player.is_on_floor():
	player.velocity += player.get_gravity() * GRAVITY_SCALE * delta

func _handle_jump(player: CharacterBody2D, delta: float):
	#update jump timer
	if _jump_timer > 0.0:
		_jump_timer -= delta
		if _jump_timer < 0.0:
			_jump_timer = 0.0
	
	# As good practice, you should replace UI actions with custom gameplay actions.	
	if Input.is_action_just_pressed("ui_accept") and _jump_timer == 0.0 and _avaliable_jumps != 0:
		player.velocity.y = JUMP_VELOCITY
		_jump_timer = JUMP_COOLDOWN
		_avaliable_jumps -= 1
		player.on_jump(_avaliable_jumps)

func _handle_horizontal_input(player: CharacterBody2D, delta: float):
	var input_axis := Input.get_axis("ui_left", "ui_right")
	if input_axis:
		player.velocity.x = move_toward(player.velocity.x, input_axis * SPEED, ACCELERATION * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, FRICTION * delta)
