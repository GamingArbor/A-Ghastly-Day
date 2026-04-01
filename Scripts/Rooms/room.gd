class_name Room
extends Area2D
var PreviousRoomNumber: int
var PreviousCameraPosition: Vector2
## This room's index. Should be unique.
@export var RoomNumber: int

func player_reset_pos() -> Vector2:
	if $PlayerResetPos != null:
		return $PlayerResetPos.global_position
	else:
		return %Player.global_position

func deadbody_reset_pos() -> Vector2:
	if $DeadbodyResetPos != null:
		return $DeadbodyResetPos.global_position
	else:
		return %Deadbody.global_position

func _on_body_entered(body: Node2D) -> void:
	if body == Global.Character:
		if %Player.possession_room_transition == true:
			%Player.room_transition_completed = false
			PreviousRoomNumber = %Player.room_number
			PreviousCameraPosition = %Camera.position
			%Player.room_number = RoomNumber
			%Camera.position = position

func _on_body_exited(body: Node2D) -> void:
	if body == Global.Character:
		if %Player.room_number == RoomNumber and %Player.room_transition_completed == false and %Player.possession_room_transition == true:
			%Player.room_number = PreviousRoomNumber
			%Camera.position = PreviousCameraPosition
		elif %Player.room_number != RoomNumber:
			%Player.room_transition_completed = true
