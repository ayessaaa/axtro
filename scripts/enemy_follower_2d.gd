extends PathFollow2D

@export var runSpeed = 80.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_progress(get_progress() + runSpeed * delta)
