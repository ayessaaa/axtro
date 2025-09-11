extends PathFollow2D

@export var runSpeed = 80.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.start_screen or Global.is_angle_dash or Global.is_mecha_flight or Global.marathon:
		return
	set_progress(get_progress() + runSpeed * delta)
