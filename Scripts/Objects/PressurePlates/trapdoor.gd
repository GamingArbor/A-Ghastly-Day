extends DoorPressurePlate

func _ready() -> void:
	move_object($Trapdoor)

func _process(delta: float) -> void:
	HandlePressurePlate($Trapdoor/DoorHB,$Sprite2D,$Trapdoor/DoorSP,$Area2D)
