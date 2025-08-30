extends Area2D

@export var powerup_type:String

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match powerup_type:
		"DoublePoint":
			Global.double_points = false
		"Magnet":
			Global.magnet = false
		"UnliBullet":
			Global.unli_bullet = false
			Global.shoot_left = 3
