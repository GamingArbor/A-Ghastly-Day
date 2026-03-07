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

func idle():
	pass

func floating():
	pass

func possess():
	pass

func air():
	pass

func dead():
	pass

# When you want to change the player's current state, use this:
# set_state(States.IDLE)
# States.IDLE could also be a different state such as FLOAT or DEAD
