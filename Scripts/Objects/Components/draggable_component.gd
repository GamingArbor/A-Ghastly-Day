class_name DraggableComponent
extends Component
## Direction the player must be forced to face when dragging from this point.
## A value of 1 indicates rightward movement; -1 indicates leftward movement.
@export var direction: int
var being_grabbed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction == -1:
		$HandsBackground.flip_h = true
		$HandsForeground.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HandsBackground.visible = being_grabbed
	$HandsForeground.visible = being_grabbed
