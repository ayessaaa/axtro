extends Area2D
@export var type = "spikes"

func _process(delta: float) -> void:
	if Global.angle_dash_animation_finished:
		position.x -= delta * Global.spike_speed
