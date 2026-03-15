class_name DragPoint
extends Node2D
# Direction the player must be forced to face when dragging from this joint
@export var direction: int
# Priority value (lower is higher priority)
@export var priority: int

var being_grabbed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HandsBackground.visible = being_grabbed
	$HandsForeground.visible = being_grabbed
