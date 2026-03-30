extends Node

enum States {IDLE, FLOAT, POSSESS, AIR, DEAD, FLOATOVER, DRAG}
enum PossessTypes {STATIC, SLIDE, HOPPING}

var player: Player
var room_number: int
var room: Room
# 1 - Intro 2 - Ending
var Cutscene: int = 0

signal restart


func _ready() -> void:
	add_user_signal("restart")
