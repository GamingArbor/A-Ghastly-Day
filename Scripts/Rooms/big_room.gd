class_name BigRoom
extends Node2D
var Camera
# Tracks if the player is in the pause menu or not
var InPauseMenu : bool = false
# Tracks if the player is in the ExitConfirm Window
var InExitConfirmWindow : bool = false
# Prevents player input in the pause menu specifically
var DenyInputInMenu : bool = false
# Prevents player input in the ExitConfirm Window
var DenyInputExitConfirmWindow : bool = false
# Tracks where the player is in the pause menu
# 0=Resume 1=Restart 2=Exit
var PauseMenuPosition : int = 0
# Tracks where the player is in the ExitConfirm Window
# 0=NO 1=YES
var ExitConfirmWindowPosition : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func has_player(room: Room):
	return room.RoomNumber == Global.room_number

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#%Camera.position.y = 336
	# Handles movement in the menu
	if Input.is_action_just_pressed("Up") and PauseMenuPosition > 0 and DenyInputInMenu == false and InPauseMenu == true:
		PauseMenuPosition -= 1
	
	if Input.is_action_just_pressed("Down") and PauseMenuPosition < 2 and DenyInputInMenu == false and InPauseMenu == true:
		PauseMenuPosition += 1
	
	# Handles movement in the ExitConfirm Window
	if Input.is_action_just_pressed("Left") and ExitConfirmWindowPosition == 1 and DenyInputExitConfirmWindow == false and InExitConfirmWindow == true:
		ExitConfirmWindowPosition = 0
	
	if Input.is_action_just_pressed("Right") and ExitConfirmWindowPosition == 0 and DenyInputExitConfirmWindow == false and InExitConfirmWindow == true:
		ExitConfirmWindowPosition = 1
	
	if Input.is_action_just_pressed("Pause") and InPauseMenu == false and DenyInputInMenu == false:
		$Camera/PauseMenu/PauseMenuAnimations.play("PauseMenuEntered")
		$Camera/PauseMenu/ExitButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Exit.png")
		$Camera/PauseMenu/RestartButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Restart.png")
		$Camera/PauseMenu/ResumeButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Resume.png")
		InPauseMenu = true
		DenyInputInMenu = true
		get_tree().paused = true
	
	if InPauseMenu == true and DenyInputInMenu == false:
		# Handles hovering over buttons
		if PauseMenuPosition == 0:
			$Camera/PauseMenu/ResumeButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Resume-Select.png")
			$Camera/PauseMenu/Arrows/RightArrow.offset.x = 0
			$Camera/PauseMenu/Arrows/RightArrow.offset.y = 0
			$Camera/PauseMenu/Arrows/LeftArrow.offset.x = 0
			$Camera/PauseMenu/Arrows/LeftArrow.offset.y = 0
		else:
			$Camera/PauseMenu/ResumeButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Resume.png")
		
		if PauseMenuPosition == 1:
			$Camera/PauseMenu/RestartButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Restart-Select.png")
			$Camera/PauseMenu/Arrows/RightArrow.offset.x = 7
			$Camera/PauseMenu/Arrows/RightArrow.offset.y = 48
			$Camera/PauseMenu/Arrows/LeftArrow.offset.x = -7
			$Camera/PauseMenu/Arrows/LeftArrow.offset.y = 48
		else:
			$Camera/PauseMenu/RestartButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Restart.png")
		
		if PauseMenuPosition == 2:
			$Camera/PauseMenu/ExitButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Exit-Select.png")
			$Camera/PauseMenu/Arrows/RightArrow.offset.x = -23
			$Camera/PauseMenu/Arrows/RightArrow.offset.y = 96
			$Camera/PauseMenu/Arrows/LeftArrow.offset.x = 23
			$Camera/PauseMenu/Arrows/LeftArrow.offset.y = 96
		else:
			$Camera/PauseMenu/ExitButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Exit.png")
		
		if Input.is_action_just_pressed("Pause") or Input.is_action_just_pressed("Float"):
			match PauseMenuPosition:
				0:
					$Camera/PauseMenu/ResumeButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Resume-Pressed.png")
					$Camera/PauseMenu/PauseMenuAnimations.play("Resume")
					DenyInputInMenu = true
				1:
					$Camera/PauseMenu/RestartButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Restart-Pressed.png")
					$Camera/PauseMenu/PauseMenuAnimations.play("Restart")
					DenyInputInMenu = true
				2:
					$Camera/PauseMenu/ExitButton.texture = preload("res://Graphics/UI/PauseMenu-Button-Exit-Pressed.png")
					$Camera/PauseMenu/PauseMenuAnimations.play("ExitConfirm")
					DenyInputInMenu = true
					DenyInputExitConfirmWindow = true
	
	if InExitConfirmWindow == true and DenyInputExitConfirmWindow == false:
		# Handles hovering over buttons
		if ExitConfirmWindowPosition == 0:
			$Camera/PauseMenu/ExitConfirmWindow/NoButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-No-Select.png")
			$Camera/PauseMenu/ExitConfirmWindow/Arrows/NoArrow.visible = true
		else:
			$Camera/PauseMenu/ExitConfirmWindow/NoButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-No.png")
			$Camera/PauseMenu/ExitConfirmWindow/Arrows/NoArrow.visible = false
		
		if ExitConfirmWindowPosition == 1:
			$Camera/PauseMenu/ExitConfirmWindow/YesButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-Yes-Select.png")
			$Camera/PauseMenu/ExitConfirmWindow/Arrows/YesArrow.visible = true
		else:
			$Camera/PauseMenu/ExitConfirmWindow/YesButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-Yes.png")
			$Camera/PauseMenu/ExitConfirmWindow/Arrows/YesArrow.visible = false
		
		if Input.is_action_just_pressed("Pause") or Input.is_action_just_pressed("Float"):
			match ExitConfirmWindowPosition:
				0:
					$Camera/PauseMenu/ExitConfirmWindow/NoButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-No-Pressed.png")
					$Camera/PauseMenu/PauseMenuAnimations.play("ReturnFromExitConfirm")
				1:
					$Camera/PauseMenu/ExitConfirmWindow/YesButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-Yes-Pressed.png")
					$Camera/PauseMenu/PauseMenuAnimations.play("Exit")

# This is where other people are going to do the awesome restart/reset room function
func ResetRoom() -> void:
	Global.restart.emit()

func AllowInput() -> void:
	DenyInputInMenu = false

# Exclusively for when the player presses the restart button in the pause menu
func LeaveMenu() -> void:
	DenyInputInMenu = false
	InPauseMenu = false
	get_tree().paused = false
	PauseMenuPosition = 0
	$Camera/PauseMenu/Arrows/RightArrow.offset.x = 0
	$Camera/PauseMenu/Arrows/RightArrow.offset.y = 0
	$Camera/PauseMenu/Arrows/LeftArrow.offset.x = 0
	$Camera/PauseMenu/Arrows/LeftArrow.offset.y = 0

func ResumeGame() -> void:
	DenyInputInMenu = false
	InPauseMenu = false
	get_tree().paused = false
	PauseMenuPosition = 0
	$Camera/PauseMenu/Arrows/RightArrow.offset.x = 0
	$Camera/PauseMenu/Arrows/RightArrow.offset.y = 0
	$Camera/PauseMenu/Arrows/LeftArrow.offset.x = 0
	$Camera/PauseMenu/Arrows/LeftArrow.offset.y = 0

func GoToExitConfirmWindow() -> void:
	DenyInputInMenu = true
	DenyInputExitConfirmWindow = false
	ExitConfirmWindowPosition = 0
	InExitConfirmWindow = true

# Exclusively for when the player returns to the pause menu from the exit confirm window by pressing NO
func ReturnToPauseMenu() -> void:
	DenyInputInMenu = false
	DenyInputExitConfirmWindow = true
	InExitConfirmWindow = false

func ExitToTitle() -> void:
	DenyInputInMenu = false
	get_tree().paused = false
	PauseMenuPosition = 0
	$Camera/PauseMenu/Arrows/RightArrow.offset.x = 0
	$Camera/PauseMenu/Arrows/RightArrow.offset.y = 0
	$Camera/PauseMenu/Arrows/LeftArrow.offset.x = 0
	$Camera/PauseMenu/Arrows/LeftArrow.offset.y = 0
	get_tree().change_scene_to_file("res://Scenes/UI/title_screen.tscn")


func _on_end_game_detection_body_entered(body: Node2D) -> void:
	if body == %Player:
		if %Player.state == Global.States.DRAG:
			$EndingTriggeredAnimation.play("Ending Triggered")

func PlayEndingCutscene() -> void:
	Global.Cutscene = 2
	get_tree().change_scene_to_file("res://Scenes/Misc/cutscene_handler.tscn")
