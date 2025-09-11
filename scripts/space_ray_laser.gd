extends Area2D

@export var type = "laser"


func _process(delta: float) -> void:
	if Global.start_screen or Global.is_angle_dash or Global.is_mecha_flight or Global.marathon:
		return
	if Global.space_ray_weapon != "laser":
		queue_free()
