extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# State Machine
# Sets state to IDLE upon entering game
enum States {IDLE, FLOAT, POSSESS, AIR, DEAD}
var state = States.IDLE

# Function for changing the player state as per the state machine
func set_state(newState):
	state = newState

func _physics_process(delta: float) -> void:
	#Run functions associated with states
	match state:
		States.IDLE:
			idle()
		States.FLOAT:
			floating()
		States.POSSESS:
			possess()
		States.AIR:
			air()
		States.DEAD:
			dead()
	
	# The Evil Gravity
	if not is_on_floor():
		# Check for Floating State to prevent gravity from applying while the player is floating
		if state != States.FLOAT:
			velocity += get_gravity() * delta

	# Floating Mechanic (Evil): Press float button to start floating, then press direction to go that way.
	# This part is for setting the floating state
	if Input.is_action_just_pressed("Float"):
		set_state(States.FLOAT)
		print("Fish")

	# The Movement (Basic Evil)
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func idle():
	pass

func floating():
	if Input.is_action_just_released("Float"):
		set_state(States.IDLE)
		print("Bass")
	
	# Handle Floating Up and Down
	if Input.is_action_pressed("Up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("Down"):
		velocity.y = SPEED
	elif Input.is_action_just_released("Up") or Input.is_action_just_released("Down"):
		velocity.y = 0

func possess():
	pass

func air():
	pass

func dead():
	pass

# When you want to change the player's current state, use this:
# set_state(States.IDLE)
# States.IDLE could also be a different state such as FLOAT or DEAD

# For checking the player's state:
# if state == States.IDLE
