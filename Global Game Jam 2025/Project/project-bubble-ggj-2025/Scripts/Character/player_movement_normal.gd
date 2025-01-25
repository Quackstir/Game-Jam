const SPEED = 150.0
const ACCELERATION = 1000.0
const JUMP_VELOCITY = -300.0
const FRICTION = 25.0
const GRAVITY_SCALE = 0.2
static var last_direction = Vector2.ZERO

func handle_input(player: CharacterBody2D, delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_axis := Input.get_axis("ui_left", "ui_right")
	
	if input_axis:
		player.velocity.x = move_toward(player.velocity.x, input_axis * SPEED, ACCELERATION * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, FRICTION * delta)
	
	apply_gravity(player,delta)
	handle_jump(player)
	
	player.move_and_slide()

func apply_gravity(player: CharacterBody2D, delta: float):
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * GRAVITY_SCALE * delta

func handle_jump(player: CharacterBody2D):
	if Input.is_action_just_pressed("ui_accept"):
		player.velocity.y = JUMP_VELOCITY
