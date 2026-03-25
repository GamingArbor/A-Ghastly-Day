class_name PossessableComponent
extends Component
## Determines how the player moves when possessing this object.
@export var PossessType: Global.PossessTypes
## The ID used to detect specific possessable objects.
@export var ObjectType: String
## The hitbox of the object this PossessableComponent is a child of.
## Used when overriding the player's hitbox while possessed.
@export var Hitbox: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
