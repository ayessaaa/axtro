extends Area2D

func _process(delta: float) -> void:
	visible = Global.mecha_flight_player == 2
	if Global.mecha_flight_player < 2 or Global.dead or !Global.is_mecha_flight:
		return
