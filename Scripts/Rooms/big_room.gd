extends Node2D
var ZoneLock = false
var Camera
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_transition_zone_1_body_entered(body: Node2D) -> void:
	print('fish')
	if body is CharacterBody2D:
		print('bass')
		if ZoneLock == false:
			print('tuna')
			if %Player.position.x >= $Camera2D.position.x:
				$Camera2D.position.x = 512
			else:
				$Camera2D.position.x = 0
			ZoneLock = true


func _on_transition_zone_1_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		if ZoneLock == true:
			print('salmon')
			ZoneLock = false
