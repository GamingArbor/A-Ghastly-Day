extends Node2D

func _ready() -> void:
	Global.restart.connect(reset)

func reset():
	var deadbody = get_parent()
	var room = Global.get_room_from_body(deadbody)
	if room == null:
		var player = deadbody.get_parent().find_child("Player")
		room = Global.get_room_from_id(player.room_number)
	deadbody.global_position = room.deadbody_reset_pos()
