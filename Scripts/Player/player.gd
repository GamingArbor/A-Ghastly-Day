extends CharacterBody2D

# Movement Constants
const SPEED = 150.0
const DRAGSPEED = SPEED * 0.75
const JUMP_VELOCITY = -400.0

# State Machine
# Sets state to IDLE upon entering game
var States = Global.States
var state = States.IDLE

var DirectionLock = 0 # For locking the axis the player floats in
var PlayedStopAnimation: bool = false # Evil Stop Moving Animation
var InDeadBodyRange: bool = false # For determining when the player can interact with the 

# Utility function for changing the player state as per the state machine
func set_state(newState):
	state = newState

func _physics_process(delta: float) -> void:
	## Run functions associated with states
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
		
	## Gravity (does not apply when floating)
	if not is_on_floor() and state != States.FLOAT:
		velocity += get_gravity() * delta
	

	# Floating Mechanic (Evil): Applies when grounded, not dragging, and pressing the float button
	if is_on_floor() and state != States.DRAG and Input.is_action_pressed("Float") and state != States.FLOAT:
			set_state(States.FLOAT) # Set the state to floating (notably prevents rerunning)
			velocity.y = 0
			DirectionLock = 0
	
	# Moving down semi-solid platforms
	if Input.is_action_pressed("Down"):
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
	if Input.is_action_just_released("Down"):
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
	
	
	move_and_slide()


# Allows for player script to know if it can pick up the body
func pick_up_body(InsideBody: bool) -> void:
	InDeadBodyRange = InsideBody

func snap_to_body():
	var delta := %Deadbody.position + %Deadbody.find_child("DragPoint").position - $DragJoint.position as Vector2
	position += delta
	%Deadbody.position -= delta

func horizontal_movement_animation(direction: int):
	var current := $AnimationPlayer.assigned_animation as String
	if direction == -1: $Sprite2D.flip_h = true
	elif direction == 1: $Sprite2D.flip_h = false
	if not $AnimationPlayer.is_playing() or current != "Idle":
		if direction == 0:
			if current != "Idle" and not PlayedStopAnimation:
				PlayedStopAnimation = true
				$AnimationPlayer.play("StopMoving")
			elif not $AnimationPlayer.is_playing():
				$AnimationPlayer.play("Idle")
		else:
			PlayedStopAnimation = false
			if current == "Idle" or current == "StopMoving":
				$AnimationPlayer.play("Moving")

func idle():
	## Idle movement (Basic Evil)
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Animation
	horizontal_movement_animation(direction)
	
	# Initiates the Dragging Body state if the player is in range of the body
	if InDeadBodyRange == true and Input.is_action_just_pressed("Interact"):
		%Deadbody.reparent(self)
		snap_to_body()
		set_state(States.DRAG)

func floating():
	# Transition to Float Ended state
	if Input.is_action_just_released("Float"):
		set_state(States.FLOATOVER)
	
	## Floating mechanic
	# Locks Direction into vertical or horizontal; 1 = vertical, 2 = horizontal
	if DirectionLock == 0:
		if Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
			DirectionLock = 1
		elif Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			DirectionLock = 2
	var direction = 0
	# Handle Floating Up and Down
	if DirectionLock == 1:
		if Input.is_action_pressed("Up"):
			velocity.y = -SPEED
		elif Input.is_action_pressed("Down"):
			velocity.y = SPEED
		elif Input.is_action_just_released("Up") or Input.is_action_just_released("Down"):
			velocity.y = 0
	# Handle Floating Left and Right
	elif DirectionLock == 2:
		if Input.is_action_pressed("Left"):
			direction = -1
		elif Input.is_action_pressed("Right"):
			direction = 1
		elif Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
			direction = 0
			
	# Animation
	horizontal_movement_animation(direction)

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
	$AnimationPlayer.play("Dragging")
	## Dragging movement (More Evil)
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * DRAGSPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Animation
	horizontal_movement_animation(direction)
	
	## Dragging mechanic
	$DragJoint.node_a = self.get_path()
	$DragJoint.node_b = %Deadbody.get_path()
	if Input.is_action_just_released("Interact"):
		set_state(States.IDLE)
		%Deadbody.reparent(self.get_parent())
		$DragJoint.node_a = NodePath("")
		$DragJoint.node_b = NodePath("")
		
## Development Notes
# When you want to change the player's current state, use this:
# set_state(States.IDLE)
# States.IDLE could also be a different state such as FLOAT or DEAD

# For checking the player's state:
# if state == States.IDLE
