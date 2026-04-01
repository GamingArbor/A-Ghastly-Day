class_name DoorPressurePlate
extends PressurePlate


func HandlePressurePlate(hitbox: CollisionShape2D, plate_sprite: Sprite2D, object_sprite: Sprite2D, area: Area2D):
	if OverlapsCrate(area):
		hitbox.disabled = true
		object_sprite.frame = 1
		plate_sprite.frame = 1
		$AudioStreamPlayer.play()
	else:
		hitbox.disabled = false
		object_sprite.frame = 0
		plate_sprite.frame = 0
