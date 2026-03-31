class_name PressurePlate
extends Node

@export var ObjectPos: Node2D

func OverlapsCrate(area: Area2D) -> bool:
	var Crates = Global.get_bodies_of_type(area,"Crate")
	return !Crates.is_empty()
	
func move_object(object: Node2D) -> void:
	if ObjectPos != null:
		object.position = ObjectPos.position
