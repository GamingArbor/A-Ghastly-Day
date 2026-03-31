class_name DoorPressurePlate
extends PressurePlate


func HandlePressurePlate(hitbox: CollisionShape2D, sprite: Sprite2D, area: Area2D):
	if OverlapsCrate(area):
		hitbox.disabled = true
		sprite.frame = 1
	else:
		hitbox.disabled = false
		sprite.frame = 0
