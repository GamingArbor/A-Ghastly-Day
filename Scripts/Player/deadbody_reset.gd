extends Node2D

func _ready() -> void:
	Global.restart.connect(reset)

func reset():
	Global.room.reset_transform(get_parent())
