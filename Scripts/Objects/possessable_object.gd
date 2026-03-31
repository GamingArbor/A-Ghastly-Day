extends CharacterBody2D
@export var possessable_component: PossessableComponent

func slide_movement() -> void:
	var direction: int
	if possessable_component.being_possessed and is_on_floor():
		direction = roundi(Input.get_axis("Left", "Right"))
	else:
		direction = 0
	if direction:
		velocity.x = direction * Global.PossessSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, Global.PossessSpeed)
	

func hopping_movement() -> void:
	var direction: int
	if possessable_component.being_possessed:
		direction = roundi(Input.get_axis("Left", "Right"))
	else:
		direction = 0
	if direction:
		velocity.x = direction * Global.PossessSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, Global.PossessSpeed)

func _physics_process(delta: float) -> void:
	#Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	match possessable_component.PossessType:
		Global.PossessTypes.SLIDE:
				slide_movement()
		Global.PossessTypes.HOPPING:
				hopping_movement()
	move_and_slide()
