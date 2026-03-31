extends DoorPressurePlate

func _ready() -> void:
	move_object($SilverDoor)

func _process(delta: float) -> void:
	HandlePressurePlate($SilverDoor/DoorHB,$SilverDoor/DoorSP,$Area2D)
