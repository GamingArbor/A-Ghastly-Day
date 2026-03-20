extends Node2D

# Used for denying input while in the title sequence
var DenyPlayerInput : bool = true
# Tracks the player's position in the menu (Which button they are currently selecting/on)
# 0=Start 1=Options 2=Exit
var MenuPosition : int = 0

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
			$Buttons/OptionsButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Options-Select.png")
		else:
			$Buttons/OptionsButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Options.png")
		
		if MenuPosition == 2:
			$Buttons/ExitButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Exit-Select.png")
		else:
			$Buttons/ExitButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Exit.png")
	
	# Handles pressing buttons
	# Checks to see if input is accepted
	if Input.is_action_just_pressed("Float") and DenyPlayerInput == false:
		match MenuPosition:
			# Functionality for Start Button
			0:
				$Buttons/StartGameButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-StartGame-Pressed.png")
				$AnimationPlayer.play("StartGame")
				DenyPlayerInput = true
			# Functionality for Options Button
			1:
				$Buttons/OptionsButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Options-Pressed.png")
			# Functionality for Exit Button
			2:
				$Buttons/ExitButton.texture_normal = preload("res://Graphics/UI/TitleMenu-Button-Exit-Pressed.png")
				$AnimationPlayer.play("ExitGame")
				DenyPlayerInput = true
	
	# Handles movement in the menu
	if Input.is_action_just_pressed("Up") and MenuPosition > 0:
		MenuPosition -= 1
	
	if Input.is_action_just_pressed("Down") and MenuPosition < 2:
		MenuPosition += 1
	

# Called when: Title sequence ends
func AllowInput() -> void:
	DenyPlayerInput = false

func QuitingGame() -> void:
	get_tree().quit()

func StartGame() -> void:
	get_tree().change_scene_to_file("res://Scenes/Rooms/Big_Room.tscn")
