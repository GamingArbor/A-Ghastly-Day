extends Component

@onready var Transform: Transform2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.restart.connect(reset)
	Transform = get_parent_object().transform

func reset():
	get_parent_object().set_transform(Transform)
	get_parent_object().find_child("CollisionShape2D").disabled = false
	get_parent_object().find_child("Sprite2D").visible = true
