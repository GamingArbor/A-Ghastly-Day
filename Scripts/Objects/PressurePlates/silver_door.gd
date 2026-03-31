extends DoorPressurePlate

func _process(delta: float) -> void:
	HandlePressurePlate($SilverDoor/DoorHB,$SilverDoor/DoorSP,$Area2D)
