extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var PlayerDragging := self.get_parent() == %Player

# Checks to see if the player has entered the area which the dead body is in (as dictated by the collision shape of the Detection Zone)
func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.pick_up_body(true)


func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.pick_up_body(false)
