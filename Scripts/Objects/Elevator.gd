extends Node2D
@export var EndPoint : int
var tween = create_tween()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Plate1/Area2D.overlaps_body(%Player):
		while $ElevatorPlatform.position.y > EndPoint:
			tween.tween_property($ElevatorPlatform , "position" , Vector2(100,100), 1)
	else:
		pass
		#while $ElevatorPlatform.position.y < self.position.y:
			#pass
