extends RigidBody2D
# Storing the Player
var Player = 0

var PlayerDragging: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 6 refers to the DRAG state
	if Global.PlayerState == 6 and PlayerDragging == false:
		Player.snap_to_body(position.x + 24)
		PlayerDragging = true
	
	# Handles movement of the body
	if PlayerDragging == true:
		position.x = Global.PlayerPositionX - 24
		position.y = Global.PlayerPositionY + 7
	
	if Global.PlayerState != 6:
		PlayerDragging = false

# Checks to see if the player has entered the area which the dead body is in (as dictated by the collision shape of the Detection Zone)
func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.pick_up_body(true)
		Player = body


func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.pick_up_body(false)
		Player = 0
