extends PressurePlate
@export var EndPoint : Vector2
var StartPoint: Vector2
var tween: Tween
var goingdown = true # trust me, bro
func _ready() -> void:
	StartPoint = $ElevatorPlatform.position

func get_percentage_up() -> float:
	return $ElevatorPlatform.position.distance_to(StartPoint)/(EndPoint.distance_to(StartPoint))

func HandlePressurePlate(elevator: AnimatableBody2D, area: Area2D):
	var has_crate = OverlapsCrate(area)
	if has_crate and goingdown:
		goingdown = false
		if tween != null: tween.kill()
		tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		var rise_time = 1 - get_percentage_up()
		tween.tween_property(elevator, "position", EndPoint, rise_time).from_current()
		print("going up from: " + str(elevator.position.y) + " to: " + str(EndPoint.y) + " in: " + str(rise_time) + "s")
	if !has_crate and !goingdown:
		goingdown = true
		tween.kill()
		tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		var fall_time = get_percentage_up()
		tween.tween_property(elevator, "position", StartPoint, fall_time).from_current()
		print("going down from: " + str(elevator.position.y) + " to: " + str(StartPoint.y) + " in: " + str(fall_time) + "s")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	HandlePressurePlate($ElevatorPlatform,$Plate/Area2D)
