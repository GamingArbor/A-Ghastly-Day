extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match Global.Cutscene:
		1:
			$CutscenePlayer.play("Intro")
		2:
			pass

func intro_end() -> void:
	get_tree().change_scene_to_file("res://Scenes/Rooms/Big_Room.tscn")

func ending_end() -> void:
	pass
