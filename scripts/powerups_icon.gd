extends Area2D

@export var powerup_type:String

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match powerup_type:
		"DoublePoint":
			Global.double_points = false
		"Magnet":
			Global.magnet = false
		"UnliBullet":
			
			if Global.mecha_flight_player == 2:
				if Global.unli_bullet_player1:
					Global.unli_bullet_player1 = false
					Global.mecha_flight_player1_bullets = 3
				else:
					Global.unli_bullet_player2 = false
					Global.mecha_flight_player2_bullets = 3
				visible = false
			else:
				Global.unli_bullet = false
				Global.shoot_left = 3
