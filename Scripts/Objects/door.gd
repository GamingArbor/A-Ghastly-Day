extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func CheckIfKey(body:PhysicsBody2D) -> bool:
	print(%Player.InteractedComponentParent.ObjectType)
	if body == %Player and %Player.InteractedComponentParent.ObjectType == "Key":
		return true
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	if %Player.state_is(Global.States.DRAG):
		self.set_collision_layer_value(1,true)
		self.set_collision_mask_value(1,true)
	else:
		self.set_collision_layer_value(1,false)
		self.set_collision_mask_value(1,false)
		
		
	print($DoorArea.get_overlapping_bodies())
	var KeyItem = $DoorArea.get_overlapping_bodies().filter(CheckIfKey)
	if KeyItem:
		print("1")
		$DoorHB.disabled = true
