class_name Component
extends Node2D

func get_actual_parent() -> Node:
	var parent = get_parent()
	if parent is Component:
		return parent.get_actual_parent()
	else:
		return parent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
