extends StaticBody2D

@export var flip_direction: bool = false
var open = false

func OverlappingKeys() -> Array[Node2D]:
	return Global.get_bodies_of_type($DoorArea,"Key")

func PlayerIsKey() -> bool:
	if %Player.state != Global.States.POSSESS: 
		return false
	return %Player.InteractedComponentParent.ObjectType == "Key"


func _process(delta: float) -> void:
	if !open:
		var Keys = OverlappingKeys()
		if !Keys.is_empty():
			open = true
			$DoorHB.disabled = true
			if flip_direction:
				$DoorSP.frame = 2
			else:
				$DoorSP.frame = 1
			$AudioStreamPlayer.play()
			deal_with(Keys)
	if !open:
		if %Player.state_is(Global.States.IDLE) or PlayerIsKey():
			self.set_collision_layer_value(1,false)
			self.set_collision_mask_value(1,false)
		else:
			self.set_collision_layer_value(1,true)
			self.set_collision_mask_value(1,true)

func deal_with(Keys: Array[Node2D]) -> void:
	var Key = Keys[0]
	var PossComponent = Key.find_child("PossessableComponent") # Cannot be null (see global.gd)
	if PossComponent.being_possessed:
		%Player.unpossess()
	Key.queue_free()
	
