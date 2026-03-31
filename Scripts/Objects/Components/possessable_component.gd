class_name PossessableComponent
extends Component
## Determines in what way the player moves when possessing this object.
@export var PossessType: Global.PossessTypes
## The ID used to detect specific possessable objects.
@export var ObjectType: String

var being_possessed: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Eyes.visible = being_possessed
