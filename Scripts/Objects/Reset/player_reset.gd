extends Node2D

func _ready() -> void:
	Global.restart.connect(reset)

func reset():
	var player = get_parent()
	
	# Handling possession
	if player.state == Global.States.POSSESS:
		player.unpossess()
		player.reset_interaction_variables()
	player.state = Global.States.IDLE
	
	# Reset player
	var room = Global.get_room_from_id(player.room_number)
	player.global_position = room.player_reset_pos()
