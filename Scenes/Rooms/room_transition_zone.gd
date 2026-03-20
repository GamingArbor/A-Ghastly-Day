extends Area2D
var PreviousRoomNumber: int
var PreviousCameraPosition: Vector2
@export var RoomNumber: int
@export var disabled: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body == %Player and !disabled:
		%Player.room_transition_completed = false
		PreviousRoomNumber = %Player.room_number
		PreviousCameraPosition = %Camera.position
		%Player.room_number = RoomNumber
		%Camera.position = position


func _on_body_exited(body: Node2D) -> void:
	if body == %Player and !disabled:
		if %Player.room_number == RoomNumber and %Player.room_transition_completed == false:
			%Player.room_number = PreviousRoomNumber
			%Camera.position = PreviousCameraPosition
		elif %Player.room_number != RoomNumber:
			%Player.room_transition_completed = true
