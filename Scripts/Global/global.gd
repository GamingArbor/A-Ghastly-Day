extends Node

@onready var Character: CharacterBody2D


enum States {IDLE, FLOAT, POSSESS, AIR, DEAD, FLOATOVER, DRAG}
enum PossessTypes {STATIC, SLIDE, HOPPING}
var PossessSpeed = 100
var HopSpeed = 240
var ElevatorSpeed = 50 # Pixels per second
# 1 - Intro 2 - Ending
var Cutscene: int = 0

signal restart


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_user_signal("restart")

func get_rooms() -> Array[Node]:
	return get_node("/root/BigRoom/Rooms").find_children("*", "Room")
	
func get_room_from_body(body) -> Node:
	var rooms = get_rooms()
	for room in rooms:
		if room.overlaps_body(body): 
			return room
	return null

func get_room_from_id(id: int) -> Node:
	var rooms = get_rooms()
	var correct_rooms = rooms.filter(func(room): return room.RoomNumber == id)
	if correct_rooms.is_empty(): return null
	else: return correct_rooms[0]

func is_possessable_object_of_type(body: Node2D, type: String) -> bool:
	var PossComponent = body.find_child("PossessableComponent")
	if PossComponent == null:
		return false
	return PossComponent.ObjectType == type

func get_bodies_of_type(area: Area2D, type: String) -> Array[Node2D]:
	return area.get_overlapping_bodies().filter(func(body): return is_possessable_object_of_type(body,type))
