extends Component

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.restart.connect(reset)

func reset():
	get_parent_object().find_child("CollisionShape2D").disabled = false
	get_parent_object().find_child("Sprite2D").visible = true
