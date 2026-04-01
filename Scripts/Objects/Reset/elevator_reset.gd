extends Component

@onready var Transform: Transform2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.restart.connect(reset)

func reset():
	if get_parent_object().tween != null: get_parent_object().tween.kill()
	get_parent_object().find_child("ElevatorPlatform").position = get_parent_object().StartPoint
