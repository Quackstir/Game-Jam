extends CharacterBody2D

const SPEED = 150.0
const ACCELERATION = 1000.0
const FRICTION = 25.0
const GRAVITY_SCALE = 0.02
static var last_direction = Vector2.ZERO
const PASSIVE_SPEED = 20.0

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	direction = direction.normalized()
	
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		last_direction.x = direction.x
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	# bubble gradually reaches passive gravity
	if direction.y:
		velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION * delta)
		last_direction.y = direction.y
	else:
		velocity.y = move_toward(velocity.y, get_gravity().y * GRAVITY_SCALE, FRICTION * delta)
	
	move_and_slide()

func _on_hazard_detector_area_entered(_area: Area2D) -> void:
	#TODO popping animation
	#TODO send signal for game over when player pops
	queue_free()
