extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Sprite.frame = 0
	pass



func PlayerIsKey() -> bool:
	if %Player.state != Global.States.POSSESS: 
		return false
	return %Player.InteractedComponentParent.ObjectType == "Key"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $DoorArea.overlaps_body(%Player) and PlayerIsKey():
		$Hitbox.disabled = true
		$Sprite.frame = 1
		return
	if %Player.state_is(Global.States.IDLE) or PlayerIsKey():
		self.set_collision_layer_value(1,false)
		self.set_collision_mask_value(1,false)
	else:
		self.set_collision_layer_value(1,true)
		self.set_collision_mask_value(1,true)
