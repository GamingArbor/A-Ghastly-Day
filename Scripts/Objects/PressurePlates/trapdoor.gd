extends DoorPressurePlate

func _process(delta: float) -> void:
	HandlePressurePlate($Trapdoor/DoorHB,$Trapdoor/DoorSP,$Area2D)
