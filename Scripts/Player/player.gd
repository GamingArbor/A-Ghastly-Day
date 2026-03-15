extends CharacterBody2D

# Movement Constants
const SPEED = 150.0
const DRAGSPEED = SPEED * 0.75
const JUMP_VELOCITY = -400.0

# State Machine
# Sets state to IDLE upon entering game
var States = Global.States
var state = States.IDLE

# Room Number
var room_number: int
var room_transition_completed = true


# Direction Variables (for different states)
var direction: int # Direction the player is facing
var float_direction = 0 # For locking the axis the player floats in (behaves diff but who  cares)
var drag_direction: int # Direction the player is forced to face when dragging

# Utility function for changing the player state
func set_state(newState):
	state = newState

# Utility function for checking the player state
func state_is(queryState):
	return state == queryState

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
	
	# Moving down semi-solid platforms
	if Input.is_action_pressed("Down"):
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
	if Input.is_action_just_released("Down"):
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
	
	
	move_and_slide()

func get_closest_drag_point() -> DragPoint:
	var drag_points_in_range = $DragZone.get_overlapping_areas().filter(func(body): return body is DragPoint)
	if drag_points_in_range.is_empty(): return null
	var best_priority_found = drag_points_in_range[0].priority
	var best_distance_found = 150
	var best_drag_point_found
	for drag_point in drag_points_in_range:
		var priority = drag_point.priority
		var distance = abs(global_position.x - drag_point.global_position.x)
		if priority <= best_priority_found:
			best_priority_found = priority
			if distance <= best_distance_found:
				best_distance_found = distance
				best_drag_point_found = drag_point
	return best_drag_point_found

func grab_drag_point(drag_point: DragPoint):
	# Account for the Deadbody flipping over
	var rotation_multiplier: int
	if %Deadbody.is_flipped():
		rotation_multiplier = -1
	else:
		rotation_multiplier = 1
	# Determine drag direction and apply to drag joint
	drag_direction = rotation_multiplier * drag_point.direction
	$DragJoint.position.x = -drag_direction * abs($DragJoint.position.x)
	# Snapping the dead body to the player
	var delta := $DragJoint.global_position - drag_point.global_position as Vector2
	%Deadbody.position += delta
	# Officially start dragging
	$DragJoint.node_a = self.get_path()
	$DragJoint.node_b = %Deadbody.get_path()
	drag_point.being_grabbed = true

func idle():
	## Idle movement (Basic Evil)
	direction = roundi(Input.get_axis("Left", "Right"))
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	## Moving to other states
	# Initiates the Float state upon pressing the float button when grounded
	if is_on_floor() and Input.is_action_pressed("Float"):
		velocity.y = 0
		float_direction = 0
		set_state(States.FLOAT)
	
	# Initiates the Drag state upon pressing the interact button (when in range of an object)
	if Input.is_action_just_pressed("Interact"):
		var closest_drag_point = get_closest_drag_point()
		if closest_drag_point != null:
			%Deadbody.reparent(self)
			grab_drag_point(closest_drag_point)
			set_state(States.DRAG)

		
func floating():
	# Transition to Float Ended state
	if Input.is_action_just_released("Float"):
		set_state(States.FLOATOVER)
	
	## Floating mechanic
	# Locks Direction into vertical or horizontal; 1 = vertical, 2 = horizontal
	if float_direction == 0:
		if Input.is_action_pressed("Up") or Input.is_action_pressed("Down"):
			float_direction = 1
		elif Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			float_direction = 2
	direction = 0
	# Handle Floating Up and Down
	if float_direction == 1:
		if Input.is_action_pressed("Up"):
			velocity.y = -SPEED
		elif Input.is_action_pressed("Down"):
			velocity.y = SPEED
		elif Input.is_action_just_released("Up") or Input.is_action_just_released("Down"):
			velocity.y = 0
	# Handle Floating Left and Right
	elif float_direction == 2:
		if Input.is_action_pressed("Left"):
			direction = -1
		elif Input.is_action_pressed("Right"):
			direction = 1
		elif Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
			direction = 0
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
	## Dragging movement (More Evil)
	direction = roundi(Input.get_axis("Left", "Right"))
	if direction == -drag_direction: 
		direction = 0 # Force correct dragging orientation
	if direction:
		velocity.x = direction * DRAGSPEED
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, DRAGSPEED)
	
	## Dragging mechanic
	var drag_points = %Deadbody.get_children().filter(func(body): return body is DragPoint) # Get drag points
	## Stop dragging when button is released
	if Input.is_action_just_released("Interact"):
		set_state(States.IDLE)
		for drag_point in drag_points:
			drag_point.being_grabbed = false
		%Deadbody.reparent(self.get_parent())
		$DragJoint.node_a = NodePath("")
		$DragJoint.node_b = NodePath("")
	var active_drag_point: DragPoint
	for drag_point in drag_points:
		if drag_point.being_grabbed == true: 
			active_drag_point = drag_point
	if active_drag_point != null: # This should never happen, but this prevents a crash if it does
	# Reverse engineer to figure out whether or not the body is supposed to be flipped
		var should_be_flipped: bool = (false if drag_direction / active_drag_point.direction == 1 else true)
		var is_flipped: bool = %Deadbody.is_flipped()
		if is_flipped != should_be_flipped:
			%Deadbody.constrain_rotation(should_be_flipped)
## Development Notes
# When you want to change the player's current state, use this:
# set_state(States.IDLE)
# States.IDLE could also be a different state such as FLOAT or DEAD

# For checking the player's state:
# if state == States.IDLE
