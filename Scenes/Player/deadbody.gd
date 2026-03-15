extends RigidBody2D

# Utility function; self-explanatory
func is_flipped() -> bool:
	return abs(%Deadbody.global_rotation_degrees) > 90

func constrain_rotation(should_be_flipped: bool):
	if should_be_flipped:
		if global_rotation_degrees < 0:
			global_rotation_degrees = -89
		if global_rotation_degrees > 0:
			global_rotation_degrees = 89
	else:
		global_rotation_degrees = clamp(global_rotation_degrees,-89,89)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
