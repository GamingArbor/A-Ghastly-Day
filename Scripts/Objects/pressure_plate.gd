extends StaticBody2D
var PressurePlatePressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass




func OverlapsCrate() -> bool:
	var Crates = Global.get_bodies_of_type($Area2D,"Crate")
	return !Crates.is_empty()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if OverlapsCrate():
		$SilverDoor/DoorHB.disabled = true
		$SilverDoor/Sprite2D.frame = 1
	else:
		$SilverDoor/DoorHB.disabled = false
		$SilverDoor/Sprite2D.frame = 0
