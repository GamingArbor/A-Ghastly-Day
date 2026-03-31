extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_drag_prompt_body_entered(body: Node2D) -> void:
	if body == %Player:
		$DragPrompt/Sprite2D.visible = true


func _on_drag_prompt_body_exited(body: Node2D) -> void:
	if body == %Player:
		$DragPrompt/Sprite2D.visible = false


func _on_possess_prompt_body_entered(body: Node2D) -> void:
	if body == %Player:
		$PossessPrompt/Sprite2D.visible = true


func _on_possess_prompt_body_exited(body: Node2D) -> void:
	if body == %Player:
		$PossessPrompt/Sprite2D.visible = false


func _on_float_prompt_body_entered(body: Node2D) -> void:
	if body == %Player:
		$FloatPrompt/Sprite2D.visible = true


func _on_float_prompt_body_exited(body: Node2D) -> void:
	if body == %Player:
		$FloatPrompt/Sprite2D.visible = false
