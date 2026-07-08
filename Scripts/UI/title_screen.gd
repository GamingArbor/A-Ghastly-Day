extends Node2D

# Used for denying input while in the title sequence
var DenyPlayerInput : bool = true
# Tracks the player's position in the menu (Which button they are currently selecting/on)
# 0=Start 1=Info 2=Exit
var MenuPosition : int = 0
# Tracks whether the player is in the info menu or not
var InInfoMenu : bool = false

# Tracks if the player is in the ExitConfirm Window
var InExitConfirmWindow : bool = false
# Prevents player input in the ExitConfirm Window
var DenyInputExitConfirmWindow : bool = true
# Tracks where the player is in the ExitConfirm Window
# 0=NO 1=YES
var ExitConfirmWindowPosition : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuPosition == 0
	$Buttons/Arrow.offset.y = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Checks if input is denied (Mostly to make sure the "pressed" sprites stay active when the button has been pressed)
	if DenyPlayerInput == false and InInfoMenu == false:
		# Handles hovering over buttons
		if MenuPosition == 0:
			$Buttons/StartGameButton.texture = preload("res://Graphics/UI/TitleMenu-Button-StartGame-Select.png")
			$Buttons/Arrow.offset.y = 0
		else:
			$Buttons/StartGameButton.texture = preload("res://Graphics/UI/TitleMenu-Button-StartGame.png")
		
		if MenuPosition == 1:
			$Buttons/OptionsButton.texture = preload("res://Graphics/UI/TitleMenu-Button-Options-Select.png")
			$Buttons/Arrow.offset.y = 48
		else:
			$Buttons/OptionsButton.texture = preload("res://Graphics/UI/TitleMenu-Button-Options.png")
		
		if MenuPosition == 2:
			$Buttons/ExitButton.texture = preload("res://Graphics/UI/TitleMenu-Button-Exit-Select.png")
			$Buttons/Arrow.offset.y = 96
		else:
			$Buttons/ExitButton.texture = preload("res://Graphics/UI/TitleMenu-Button-Exit.png")
	
	# Handles pressing buttons
	# Checks to see if input is accepted
	if DenyPlayerInput == false and InInfoMenu == false:
		if Input.is_action_just_pressed("Float") or Input.is_action_just_pressed("Pause"):
			match MenuPosition:
				# Functionality for Start Button
				0:
					$Buttons/StartGameButton.texture = preload("res://Graphics/UI/TitleMenu-Button-StartGame-Pressed.png")
					$AnimationPlayer.play("StartGame")
					DenyPlayerInput = true
				# Functionality for Options Button
				1:
					$Buttons/OptionsButton.texture = preload("res://Graphics/UI/TitleMenu-Button-Options-Pressed.png")
					$AnimationPlayer.play("InfoMenuEnter")
					DenyPlayerInput = true
					InInfoMenu = true
				# Functionality for Exit Button
				2:
					$Buttons/ExitButton.texture = preload("res://Graphics/UI/TitleMenu-Button-Exit-Pressed.png")
					$AnimationPlayer.play("ConfirmWindow")
					DenyPlayerInput = true
	
	if InExitConfirmWindow == true and DenyInputExitConfirmWindow == false:
		# Handles hovering over buttons
		if ExitConfirmWindowPosition == 0:
			$ExitConfirmWindow/NoButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-No-Select.png")
			$ExitConfirmWindow/Arrows/NoArrow.visible = true
		else:
			$ExitConfirmWindow/NoButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-No.png")
			$ExitConfirmWindow/Arrows/NoArrow.visible = false
		
		if ExitConfirmWindowPosition == 1:
			$ExitConfirmWindow/YesButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-Yes-Select.png")
			$ExitConfirmWindow/Arrows/YesArrow.visible = true
		else:
			$ExitConfirmWindow/YesButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-Yes.png")
			$ExitConfirmWindow/Arrows/YesArrow.visible = false
		
		if Input.is_action_just_pressed("Pause") or Input.is_action_just_pressed("Float"):
			match ExitConfirmWindowPosition:
				0:
					$ExitConfirmWindow/NoButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-No-Pressed.png")
					$AnimationPlayer.play("ConfirmWindowReturn")
				1:
					$ExitConfirmWindow/YesButton.texture = preload("res://Graphics/UI/ExitConfirm-Button-Yes-Pressed.png")
					$AnimationPlayer.play("ExitGame")
	
	
	# Handles leaving the info/options menu
	if InInfoMenu == true and DenyPlayerInput == false and Input.is_action_just_pressed("Interact"):
		$AnimationPlayer.play("InfoMenuExit")
		DenyPlayerInput = true
		InInfoMenu = false
	
	# Handles movement in the menu
	if DenyPlayerInput == false and InInfoMenu == false:
		if Input.is_action_just_pressed("Up") and MenuPosition > 0:
			MenuPosition -= 1
		
		if Input.is_action_just_pressed("Down") and MenuPosition < 2:
			MenuPosition += 1
	
	# Handles movement in the Exit Confirm Window
	if DenyInputExitConfirmWindow == false and InExitConfirmWindow == true:
		if Input.is_action_just_pressed("Left") and ExitConfirmWindowPosition == 1:
			ExitConfirmWindowPosition = 0
		
		if Input.is_action_just_pressed("Right") and ExitConfirmWindowPosition == 0:
			ExitConfirmWindowPosition = 1
	

# Called when: Title sequence ends, entering or exiting info menu
func AllowInput() -> void:
	DenyPlayerInput = false

func ExitConfirmWindowEnter() -> void:
	InExitConfirmWindow = true
	DenyInputExitConfirmWindow = false

func ExitConfirmWindowExit() -> void:
	InExitConfirmWindow = false
	DenyInputExitConfirmWindow = true
	DenyPlayerInput = false

func QuitingGame() -> void:
	get_tree().quit()

func StartGame() -> void:
	Global.Cutscene = 1
	get_tree().change_scene_to_file("res://Scenes/Misc/cutscene_handler.tscn")
