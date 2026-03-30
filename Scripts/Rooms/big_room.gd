extends Node2D
var Camera
# Tracks if the player is in the pause menu or not
var InPauseMenu : bool = false
# Prevents player input in the pause menu specifically
var DenyInputInMenu : bool = false
# Tracks where the player is in the pause menu
# 0=Resume 1=Restart 2=Exit
var PauseMenuPosition : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func has_player(room: Room):
	return room.RoomNumber == Global.room_number

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%Camera.position.y = 336
	# Handles movement in the menu
	if Input.is_action_just_pressed("Up") and PauseMenuPosition > 0:
		PauseMenuPosition -= 1
	
	if Input.is_action_just_pressed("Down") and PauseMenuPosition < 2:
		PauseMenuPosition += 1
	
	if Input.is_action_just_pressed("Pause") and InPauseMenu == false and DenyInputInMenu == false:
		$Camera/PauseMenu/PauseMenuAnimations.play("PauseMenuEntered")
		InPauseMenu = true
		DenyInputInMenu = true
	
	if InPauseMenu == true and DenyInputInMenu == false:
		# Handles hovering over buttons
		if PauseMenuPosition == 0:
			$Camera/PauseMenu/ResumeButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Resume-Select.png")
		else:
			$Camera/PauseMenu/ResumeButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Resume.png")
		
		if PauseMenuPosition == 1:
			$Camera/PauseMenu/RestartButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Restart-Select.png")
		else:
			$Camera/PauseMenu/RestartButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Restart.png")
		
		if PauseMenuPosition == 2:
			$Camera/PauseMenu/ExitButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Exit-Select.png")
		else:
			$Camera/PauseMenu/ExitButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Exit.png")
		
		if Input.is_action_just_pressed("Pause") or Input.is_action_just_pressed("Float"):
			match PauseMenuPosition:
				0:
					$Camera/PauseMenu/ResumeButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Resume-Pressed.png")
					$Camera/PauseMenu/PauseMenuAnimations.play("Resume")
					DenyInputInMenu = true
				1:
					$Camera/PauseMenu/RestartButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Restart-Pressed.png")
					$Camera/PauseMenu/PauseMenuAnimations.play("Restart")
					DenyInputInMenu = true
				2:
					$Camera/PauseMenu/ExitButton.texture_normal = preload("res://Graphics/UI/PauseMenu-Button-Exit-Pressed.png")
					$Camera/PauseMenu/PauseMenuAnimations.play("Exit")
					DenyInputInMenu = true

# This is where other people are going to do the awesome restart/reset room function
func ResetRoom() -> void:
	Global.restart.emit()

func AllowInput() -> void:
	DenyInputInMenu = false

# Exclusively for when the player presses the restart button in the pause menu
func LeaveMenu() -> void:
	DenyInputInMenu = false
	InPauseMenu = false

func ResumeGame() -> void:
	DenyInputInMenu = false
	InPauseMenu = false

func ExitToTitle() -> void:
	DenyInputInMenu = false
	get_tree().change_scene_to_file("res://Scenes/UI/title_screen.tscn")
