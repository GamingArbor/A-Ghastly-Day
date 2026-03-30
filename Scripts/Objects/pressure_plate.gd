extends StaticBody2D
var PressurePlatePressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func IsCrate(body: PhysicsBody2D) -> bool:
	print("IsCrate")
	var HasPossComp = body.find_children("*","PossessableComponent")
	print(HasPossComp)
	if HasPossComp.is_empty() == true:
		return false
	return HasPossComp[0].ObjectType == "Crate"



func PlayerIsCrate() -> bool:
	if %Player.state != Global.States.POSSESS: 
		return false
	return %Player.InteractedComponentParent.ObjectType == "Crate"



func CrateColliding() -> bool:
	print("CrateColliding")
	var CrateCollision = $Area2D.get_overlapping_bodies().filter(IsCrate)
	return CrateCollision.is_empty() != true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ($Area2D.overlaps_body(%Player) and PlayerIsCrate()) or (CrateColliding()):
		$SilverDoor/DoorHB.disabled = true
		$SilverDoor/Sprite2D.frame = 1
	else:
		$SilverDoor/DoorHB.disabled = false
		$SilverDoor/Sprite2D.frame = 0
