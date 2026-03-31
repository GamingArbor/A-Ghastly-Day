extends DoorPressurePlate

func _ready() -> void:
	move_object($SilverDoor)

func _process(delta: float) -> void:
	HandlePressurePlate($SilverDoor/DoorHB,$Sprite2D,$SilverDoor/DoorSP,$Area2D)
