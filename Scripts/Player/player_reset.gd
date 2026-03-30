extends Node2D

func _ready() -> void:
	Global.restart.connect(reset)

func reset():
	var Parent = get_parent()
	Global.room.reset_transform(Parent)
	
	# Handling possession
	if Parent.state == Global.States.POSSESS:
		Parent.unpossess()
		Parent.reset_interaction_variables()
	Parent.state = Global.States.IDLE
