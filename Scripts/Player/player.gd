class_name Player
extends CharacterBody2D

# Movement Constants
const SPEED = 150.0
const DRAG_SPEED = SPEED * 0.75
const JUMP_VELOCITY = -400.0

# State Machine
# Sets state to IDLE upon entering game
var States = Global.States
var state = States.IDLE

## Room the player is in, indexed as an integer.
## Should be set to the room the player starts in.
@export var room_number: int
var room_transition_completed: bool = true

# Direction Variables (for different states)
var direction: int # Direction the player is facing
var float_direction: int # For locking the axis the player floats in (behaves diff but who cares)
var drag_direction: int # Direction the player is forced to face when dragging

# Interaction Variables (see bottom for info on components)
var InteractedComponent: InteractableComponent # The component that was chosen to interact with
var InteractedComponentParent: Node2D # Typically, this is a PossessableComponent or a DraggableComponent
var InteractedObject: Node2D # The object that was interacted with. See component.gd

# Variables used for floating stamina
var StartingX
var StartingY
# Utility function for changing the player state
func set_state(newState):
	state = newState

# Utility function for checking the player state
func state_is(queryState) -> bool:
	return state == queryState

# Utility function to reset variables when no longer interacting with an object
func reset_interaction_variables():
	InteractedComponent = null
	InteractedComponentParent = null
	InteractedObject = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.Character = %Player

func _physics_process(delta: float) -> void:
	# Run functions associated with states
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
	
	if state == States.POSSESS:
		return # Player movement is not processed when possessing
	# Gravity (applies in all states except the FLOAT and POSSESS states)
	if not is_on_floor() and state != States.FLOAT:
		velocity += get_gravity() * delta
	
	# Moving down semi-solid platforms
	# Checks if the player is dragging the body to prevent weird interactions with the player going down a semi-solid and the body not following
	if Input.is_action_pressed("Down"):
		set_collision_layer_value(2, false)
		set_collision_mask_value(2, false)
	if Input.is_action_just_released("Down"):
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
	
	# Apply movement for this frame
	move_and_slide()

# Search through InteractableComponents in range to find object to interact with
func choose_interactable_component() -> InteractableComponent:
	var interactable_components = $InteractionZone.get_overlapping_areas().map(func(area): return area.get_parent()).filter(func(body): return body is InteractableComponent)
	if interactable_components.is_empty(): return null
	var best_priority_found = interactable_components[0].priority
	var best_distance_found = abs(global_position.x -  interactable_components[0].global_position.x)
	var best_interactable_component = interactable_components[0]
	for interactable_component in interactable_components:
		var priority = interactable_component.priority
		var distance = abs(global_position.x -  interactable_component.global_position.x)
		if priority <= best_priority_found:
			best_priority_found = priority
			if distance <= best_distance_found:
				best_distance_found = distance
				best_interactable_component = interactable_component
	
	return best_interactable_component

# Function used to begin dragging. Really complicated
func grab_drag_point(drag_point: DraggableComponent):
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

func unpossess():
	$Sprite.visible = true
	$Hitbox.disabled = false
	Global.Character = self
	InteractedComponentParent.being_possessed = false
	reset_interaction_variables()
	set_state(States.IDLE)

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
		StartingX = self.position.x
		StartingY = self.position.y
		set_state(States.FLOAT)
	# Interaction with Objects
	if Input.is_action_just_pressed("Interact"):
		# Search for what to interact with
		InteractedComponent = choose_interactable_component() 
		if InteractedComponent != null:
			InteractedComponentParent = InteractedComponent.get_parent()
			InteractedObject = InteractedComponent.get_parent_object()
			if InteractedComponentParent is not Component: # If we want to add interaction that isn't possession or dragging
				pass # When the InteractedComponent is a direct child of the object
			elif InteractedComponentParent is DraggableComponent: # Transition to DRAG state
				InteractedObject.reparent(self) # Make interacted object child of self
				
				# Starting to drag is really complicated; separated into its own function
				grab_drag_point(InteractedComponentParent)
				
				set_state(States.DRAG)
			elif InteractedComponentParent is PossessableComponent: # Transition to POSSESS state
				
				## Start to possess
				set_state(States.POSSESS)
				

func StartPossessing() -> void:
	# This used to be under the ## Start to possess section above
	$Sprite.visible = false # Hide player sprite
	$Hitbox.disabled = true # Disable player hitbox
	Global.Character = InteractedObject
	InteractedComponentParent.being_possessed = true # Initiate possession officially
	

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
		if abs(self.position.y - StartingY) <= 64:
			if Input.is_action_pressed("Up"):
				velocity.y = -SPEED
			elif Input.is_action_pressed("Down"):
				velocity.y = SPEED
			elif Input.is_action_just_released("Up") or Input.is_action_just_released("Down"):
				velocity.y = 0
		else:
			set_state(States.FLOATOVER)
	# Handle Floating Left and Right
	elif float_direction == 2:
		if abs(self.position.x - StartingX) <= 192:
			if Input.is_action_pressed("Left"):
				direction = -1
			elif Input.is_action_pressed("Right"):
				direction = 1
			elif Input.is_action_just_released("Left") or Input.is_action_just_released("Right"):
				direction = 0
		else:
			set_state(States.FLOATOVER)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func possess():
	# Stop possessing
	if Input.is_action_just_pressed("Interact"):
		unpossess()
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
		velocity.x = direction * DRAG_SPEED
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, DRAG_SPEED)
	
	# Dragging failsafe: reverse engineer to figure out whether or not the body is supposed to be flipped
	var should_be_flipped: bool = (false if drag_direction / InteractedComponentParent.direction == 1 else true)
	var is_flipped: bool = %Deadbody.is_flipped()
	if is_flipped != should_be_flipped:
		%Deadbody.constrain_rotation(should_be_flipped)
	
	# Stop dragging when button is released
	if Input.is_action_just_released("Interact"):
		InteractedObject.reparent(self.get_parent()) # Put the deadbody back
		
		InteractedComponentParent.being_grabbed = false
		$DragJoint.node_a = NodePath("")
		$DragJoint.node_b = NodePath("")
		reset_interaction_variables()
		set_state(States.IDLE)

### Implementation Notes

## States:
# When you want to change the player's current state, use this:
# set_state(States.IDLE)
# States.IDLE could also be a different state such as FLOAT or DEAD

# For checking the player's state:
# if state_is(States.IDLE)

## Components:
# Because the player can interact with the body to drag, or an item to possess,
# there are DraggableComponent and PossessableComponent nodes (composition!).

# Each takes a child InteractableComponent. InteractableComponents are searched
# for when the player presses the Interact button by priority and distance.

# All of these nodes, fittingly, extend the Component class (helpful). Look at
# possessable items and the deadbody to get a sense for how this is implemented.
