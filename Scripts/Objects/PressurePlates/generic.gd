class_name PressurePlate
extends Node

func OverlapsCrate(area: Area2D) -> bool:
	var Crates = Global.get_bodies_of_type(area,"Crate")
	return !Crates.is_empty()
