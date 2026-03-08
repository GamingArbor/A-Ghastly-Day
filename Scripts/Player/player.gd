extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# State Machine
# Sets state to IDLE upon entering game
enum States {IDLE, FLOAT, POSSESS, AIR, DEAD, FLOATOVER, DRAG}
var state = States.IDLE

# For locking the axis the player floats in
var DirectionLock = 0

# For checking to see if the player can intact with various objects
var InDeadBodyRange: bool = false


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
		States.FLOATOVER:
			floatover()
		States.DRAG:
			drag()
		
	
	# The Evil Gravity
	if not is_on_floor():
		# Check for Floating State to prevent gravity from applying while the player is floating
		if state != States.FLOAT:
			velocity += get_gravity() * delta

	# Floating Mechanic (Evil): Press float button to start floating, then press direction to go that way.
	# This part is for setting the floating state
	# Checks to make sure the player is on the floor and not dragging the body
	if Input.is_action_just_pressed("Float") and is_on_floor() and state != States.DRAG:
		set_state(States.FLOAT)
		velocity.y = 0
		DirectionLock = 0
	
	# Handles moving down semi-solid platforms
	if Input.is_action_pressed("Down"):
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
	if Input.is_action_just_released("Down"):
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
	
	# The Movement (Basic Evil)
	var direction := Input.get_axis("Left", "Right")
	if state != States.FLOAT and state != States.FLOATOVER:
		if direction:
			# Reduces speed of player if they are dargging the body
			if state == States.DRAG:
				velocity.x = direction * SPEED * 0.75
			else:
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	# Initiates the Dragging Body state if the player is in range of the body
	if InDeadBodyRange == true and Input.is_action_just_pressed("Interact"):
		set_state(States.DRAG)
		print("Fish")


# Responsible for the player end of picking up the body
func pick_up_body(InsideBody: bool) -> void:
	InDeadBodyRange = InsideBody


func idle():
	pass

func floating():
	if Input.is_action_just_released("Float"):
		set_state(States.FLOATOVER)
	
	# Locks Direction into vertical or horizontal; 1 = vertical, 2 = horizontal
	
	if DirectionLock == 0:
		if Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
			DirectionLock = 1
	if DirectionLock == 0:
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			DirectionLock = 2
	
	var direction = 0
	
	# Handle moving in orthagonal directions while floating
	if DirectionLock == 1:
		if Input.is_action_pressed("Up"):
			velocity.y = -SPEED
		elif Input.is_action_pressed("Down"):
			velocity.y = SPEED
		elif Input.is_action_just_released("Up") or Input.is_action_just_released("Down"):
			velocity.y = 0
	elif DirectionLock == 2:
		if Input.is_action_pressed("Left"):
			direction = -1
		elif Input.is_action_pressed("Right"):
			direction = 1
		elif Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
			direction = 0
	# Handle Floating Up and Down

	


	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func possess():
	pass

func air():
	pass

func dead():
	pass

func floatover():
	if is_on_floor():
		set_state(States.IDLE)

func drag():
	if Input.is_action_just_released("Interact"):
		set_state(States.IDLE)
		print("Bass")

# When you want to change the player's current state, use this:
# set_state(States.IDLE)
# States.IDLE could also be a different state such as FLOAT or DEAD

# For checking the player's state:
# if state == States.IDLE
