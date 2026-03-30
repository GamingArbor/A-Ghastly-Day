class_name Room
extends Area2D
var PreviousRoomNumber: int
var PreviousCameraPosition: Vector2
## This room's index. Should be unique.
@export var RoomNumber: int
@export var PlayerResetPos: Node2D
@export var DeadbodyResetPos: Node2D
func reset_transform(body: Node2D):
	if body == %Player:
		if PlayerResetPos != null:
			body.transform = PlayerResetPos.transform
	if body == %Deadbody:
		if DeadbodyResetPos != null:
			body.transform = DeadbodyResetPos.transform

func _on_body_entered(body: Node2D) -> void:
	if body == %Player:
		%Player.room_transition_completed = false
		PreviousRoomNumber = %Player.room_number
		PreviousCameraPosition = %Camera.position
		%Player.room_number = RoomNumber
		%Camera.position = position


func _on_body_exited(body: Node2D) -> void:
	if body == %Player:
		if %Player.room_number == RoomNumber and %Player.room_transition_completed == false:
			%Player.room_number = PreviousRoomNumber
			%Camera.position = PreviousCameraPosition
		elif %Player.room_number != RoomNumber:
			%Player.room_transition_completed = true
