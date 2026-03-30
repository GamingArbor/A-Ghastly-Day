extends Node2D

# Used for denying input while in the title sequence
var DenyPlayerInput : bool = true
# Tracks the player's position in the menu (Which button they are currently selecting/on)
# 0=Start 1=Info 2=Exit
var MenuPosition : int = 0
# Tracks whether the player is in the info menu or not
var InInfoMenu : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Checks if input is denied (Mostly to make sure the "pressed" sprites stay active when the button has been pressed)
	if DenyPlayerInput == false:
		# Handles hovering over buttons
		if MenuPosition == 0:
			$Buttons/StartGameButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-StartGame-Select.png")
		else:
			$Buttons/StartGameButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-StartGame.png")
		
		if MenuPosition == 1:
			$Buttons/OptionsButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Info-Select.png")
		else:
			$Buttons/OptionsButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Info.png")
		
		if MenuPosition == 2:
			$Buttons/ExitButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Exit-Select.png")
		else:
			$Buttons/ExitButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Exit.png")
	
	# Handles pressing buttons
	# Checks to see if input is accepted
	if DenyPlayerInput == false and InInfoMenu == false:
		if Input.is_action_just_pressed("Float") or Input.is_action_just_pressed("Pause"):
			match MenuPosition:
				# Functionality for Start Button
				0:
					$Buttons/StartGameButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-StartGame-Pressed.png")
					$AnimationPlayer.play("StartGame")
					DenyPlayerInput = true
				# Functionality for Options Button
				1:
					$Buttons/OptionsButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Info-Pressed.png")
					$AnimationPlayer.play("InfoMenuEnter")
					DenyPlayerInput = true
					InInfoMenu = true
				# Functionality for Exit Button
				2:
					$Buttons/ExitButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Exit-Pressed.png")
					$AnimationPlayer.play("ExitGame")
					DenyPlayerInput = true
	
	# Handles leaving the info menu
	if InInfoMenu == true and DenyPlayerInput == false and Input.is_action_just_pressed("Interact"):
		$AnimationPlayer.play("InfoMenuExit")
		DenyPlayerInput = true
		InInfoMenu = false
	
	# Handles movement in the menu
	if Input.is_action_just_pressed("Up") and MenuPosition > 0:
		MenuPosition -= 1
	
	if Input.is_action_just_pressed("Down") and MenuPosition < 2:
		MenuPosition += 1
	

# Called when: Title sequence ends, entering or exiting info menu
func AllowInput() -> void:
	DenyPlayerInput = false

func QuitingGame() -> void:
	get_tree().quit()

func StartGame() -> void:
	Global.Cutscene = 1
	get_tree().change_scene_to_file("res://Scenes/Misc/cutscene_handler.tscn")
