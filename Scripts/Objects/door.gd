extends StaticBody2D

var open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DoorSP.frame = 0



func PlayerIsKey() -> bool:
	if %Player.state != Global.States.POSSESS: 
		return false
	return %Player.InteractedComponentParent.ObjectType == "Key"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Opening and closing
	if $DoorArea.overlaps_body(%Player) and PlayerIsKey():
		open = true
	if open:
		$DoorHB.disabled = true
		$DoorSP.frame = 1
	else:
		$DoorHB.disabled = false
		$DoorSP.frame = 0
		return
	# Collision when closed
	if %Player.state_is(Global.States.IDLE) or PlayerIsKey():
		self.set_collision_layer_value(1,false)
		self.set_collision_mask_value(1,false)
	else:
		self.set_collision_layer_value(1,true)
		self.set_collision_mask_value(1,true)
