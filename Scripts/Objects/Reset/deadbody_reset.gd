extends Node2D

func _ready() -> void:
	Global.restart.connect(reset)

func reset():
	var deadbody = get_parent()
	var room = Global.get_room_from_body(deadbody)
	deadbody.global_position = room.deadbody_reset_pos()
