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
		$Trapdoor/DoorHB.disabled = true
		$Trapdoor/Sprite2D.frame = 1
	else:
		$Trapdoor/DoorHB.disabled = false
		$Trapdoor/Sprite2D.frame = 0
