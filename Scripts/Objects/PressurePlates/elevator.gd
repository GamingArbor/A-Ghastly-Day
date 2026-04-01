extends PressurePlate
@export var EndPoint : Vector2
var StartPoint: Vector2
var tween: Tween
var goingdown = true # trust me, bro
func _ready() -> void:
	move_object($ElevatorPlatform)
	StartPoint = $ElevatorPlatform.position

func get_move_time(target: Vector2) -> float:
	return $ElevatorPlatform.position.distance_to(target) / Global.ElevatorSpeed

func HandlePressurePlate(elevator: AnimatableBody2D, area: Area2D):
	var has_crate = OverlapsCrate(area)
	$Plate/Sprite2D.frame = has_crate
	if has_crate and goingdown:
		goingdown = false
		if tween != null: tween.kill()
		tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		var rise_time = get_move_time(EndPoint)
		tween.tween_property(elevator, "position", StartPoint + EndPoint, rise_time).from_current()
	if !has_crate and !goingdown:
		goingdown = true
		tween.kill()
		tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		var fall_time = get_move_time(StartPoint)
		tween.tween_property(elevator, "position", StartPoint, fall_time).from_current()
	if tween != null:
		print(tween.is_running())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	HandlePressurePlate($ElevatorPlatform,$Plate/Area2D)
