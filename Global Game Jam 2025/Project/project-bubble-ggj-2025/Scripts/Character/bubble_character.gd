extends CharacterBody2D


const SPEED = 150.0
const ACCELERATION = 1200.0
const FRICTION = 200.0
const STOPPING_FRICTION = 8.0
const GRAVITY_SCALE = 0.02
static var last_direction = Vector2.ZERO
const PASSIVE_SPEED = 20.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * GRAVITY_SCALE * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	direction = direction.normalized()
	
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		last_direction.x = direction.x
	else:
		if abs(velocity.x) < PASSIVE_SPEED + 1:
			velocity.x = move_toward(velocity.x, 0, STOPPING_FRICTION * delta)
		else:
			velocity.x = move_toward(velocity.x, last_direction.x * PASSIVE_SPEED, FRICTION * delta)
		
	
	# bubble gradually reaches passive gravity
	if direction.y:
		velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION * delta)
		last_direction.y = direction.y
	else:
		#velocity.y = move_toward(velocity.y, get_gravity().y * GRAVITY_SCALE, FRICTION * delta)
		#velocity.y = move_toward(velocity.y, last_direction.y * PASSIVE_SPEED, FRICTION * delta)
		if abs(velocity.y) < PASSIVE_SPEED + 1:
			velocity.y = move_toward(velocity.y, 0, STOPPING_FRICTION * delta)
		else:
			velocity.y = move_toward(velocity.y, last_direction.y * PASSIVE_SPEED, FRICTION * delta)
	
	move_and_slide()
