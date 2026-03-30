extends Node2D
@export var RisingLimit : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Plate1/Area2D.overlaps_body(%Player):
		print($ElevatorPlatform.position.y)
		while $ElevatorPlatform.position.y < RisingLimit:
			$ElevatorPlatform.position.y += 1
	elif $Plate2/Area2D.overlaps_body(%Player):
		print($ElevatorPlatform.position.y)
		while $ElevatorPlatform.position.y > self.position.y:
			$ElevatorPlatform.position.y -= 1
