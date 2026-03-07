extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# The Evil Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Floating Mechanic (Evil): Press float button to start floating, then press direction to go that way.
	if Input.is_action_just_pressed("Float"):
		velocity.y = JUMP_VELOCITY

	# The Movement (Basic Evil)
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
