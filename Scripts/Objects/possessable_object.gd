extends CharacterBody2D
@export var possessable_component: PossessableComponent
var direction: int
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


func hopping_movement(delta: float) -> void:
	if is_on_floor():
		direction = 0 # Prevent sliding on ground nefariously
	# All the conditionals
	if Input.is_action_pressed("Float"):
		if possessable_component.being_possessed:
			direction = roundi(Input.get_axis("Left", "Right"))
			if is_on_floor():
				velocity.y = -Global.HopSpeed
	# Apply horizontal movement
	if direction:
		velocity.x = direction * Global.PossessSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, Global.PossessSpeed)
	shake_animation()

func teleport() -> void:
	%Player.global_position = global_position
	if possessable_component.PossessType == Global.PossessTypes.HOPPING:
		if $RayCast2D.is_colliding():
			%Player.position.y -= (15 - $RayCast2D.global_position.distance_to($RayCast2D.get_collision_point()))

func shake_animation() -> void:
	if is_on_floor():
		$AnimationPlayer.stop()
	elif !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Shake")

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	match possessable_component.PossessType:
		Global.PossessTypes.SLIDE:
			slide_movement()
		Global.PossessTypes.HOPPING:
			hopping_movement(delta)
	move_and_slide()
