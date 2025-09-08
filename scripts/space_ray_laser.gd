extends Area2D

@export var type = "laser"


func _process(delta: float) -> void:
	if Global.space_ray_weapon != "laser":
		queue_free()
