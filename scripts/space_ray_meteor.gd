extends Area2D

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray:
		return
	position.y += 1
	position.x -= 3
