extends AnimationTree
@onready var Player : CharacterBody2D = get_owner()
@export var animation_tree : AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Determine direction to orient player sprite
	var direction: int
	if Player.state == Global.States.DRAG: 
		direction = Player.drag_direction
	else:
		direction = Player.direction
	
	# Apply horizontal flip as needed
	var Sprite: Sprite2D = Player.find_child("Sprite")
	if direction == 1: Sprite.flip_h = false
	if direction == -1: Sprite.flip_h = true
