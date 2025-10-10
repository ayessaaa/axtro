extends Area2D

@onready var score: Label = get_node("/root/Game/Score")
@export var type = "star"
@onready var powerup_sound = get_parent().get_node("PowerupSound")
@onready var powerup_animation = get_parent().get_parent().get_parent().get_node("PowerupLabel/AnimationPlayer")
@onready var powerup_name = get_parent().get_parent().get_parent().get_node("PowerupLabel/PowerupName")
@onready var powerup_sprite = get_parent().get_parent().get_parent().get_node("PowerupLabel/PowerupSprite")

@onready var double_points_icon_animation = get_parent().get_parent().get_parent().get_node("Powerups/DoublePointIcon/AnimationPlayer")
@onready var double_points_icon = get_parent().get_parent().get_parent().get_node("Powerups/DoublePointIcon/AnimationPlayer")

@onready var magnet_icon_animation = get_parent().get_parent().get_parent().get_node("Powerups/MagnetIcon/AnimationPlayer")
@onready var magnet_icon = get_parent().get_parent().get_parent().get_node("Powerups/MagnetIcon/AnimationPlayer")

@onready var unli_bullet_icon = get_parent().get_parent().get_parent().get_node("Powerups/UnliBulletIcon/AnimationPlayer")

@onready var player1_unli_bullet_icon = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/UnliBulletIcon/AnimationPlayer")
@onready var player1_unli_bullet_icon_area = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/UnliBulletIcon")
@onready var player1_unli_bullet_icon_sprite = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/UnliBulletIcon/Sprite2D")
@onready var player2_unli_bullet_icon = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/UnliBulletIcon/AnimationPlayer")
@onready var player2_unli_bullet_icon_area  = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/UnliBulletIcon")
@onready var player2_unli_bullet_icon_sprite = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/UnliBulletIcon/Sprite2D")

@onready var player1_magnet_icon = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/MagnetIcon/AnimationPlayer")
@onready var player1_magnet_icon_area = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/MagnetIcon")
@onready var player1_magnet_icon_sprite = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/MagnetIcon/Sprite2D")
@onready var player2_magnet_icon = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/MagnetIcon/AnimationPlayer")
@onready var player2_magnet_icon_area = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/MagnetIcon")
@onready var player2_magnet_icon_sprite = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/MagnetIcon/Sprite2D")

@onready var player1_double_point_icon = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/DoublePointIcon/AnimationPlayer")
@onready var player1_double_point_icon_area = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/DoublePointIcon")
@onready var player1_double_point_icon_sprite = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/DoublePointIcon/Sprite2D")
@onready var player2_double_point_icon = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/DoublePointIcon/AnimationPlayer")
@onready var player2_double_point_icon_area = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/DoublePointIcon")
@onready var player2_double_point_icon_sprite = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/DoublePointIcon/Sprite2D")

@onready var player1_shield_icon_area = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player1/Powerups/Shield")
@onready var player2_shield_icon_area = get_parent().get_parent().get_parent().get_node("TwoPlayers/Player2/Powerups/Shield")

@onready var character_animation = get_parent().get_parent().get_parent().get_node("Character/AnimationPlayer")
@onready var character2_animation = get_parent().get_parent().get_parent().get_node("Character2/AnimationPlayer")


@onready var animation_player: AnimationPlayer = $AnimationPlayer
var texture 

#var powerups_array = ["Shield", "DoublePoints", "Magnet", "UnliBullet"]
var powerups_array = ["Shield"]

func _process(delta: float) -> void:
	pass
	#if Global.free_regular_mode_objects:
		#self.queue_free()
		#return

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		if Global.is_angle_dash:
			return
		powerup_sound.play()
		animation_player.play("pick_up")
		var powerup = powerups_array[randi_range(0, len(powerups_array)-1)]
		print(powerup)
		match powerup:
			"Shield":
				if Global.mecha_flight_player == 2:
					if area.player_number == 1:
						player1_shield_icon_area.visible = true
						Global.shield_player1 = true
						Global.powerup_player1 = "Shield"
						character_animation.play("shield_fade_in")
					else:
						player2_shield_icon_area.visible = true
						Global.shield_player2 = true
						Global.powerup_player2 = "Shield"
						character2_animation.play("shield_fade_in")
				else:
					texture = load("res://assets/IMG_1665.PNG")
					powerup_sprite.texture = texture
					Global.powerup = "Shield"
					powerup_name.text = "Shield"
					slow_down()
					powerup_animation.play("default")
					Global.powerup_animation_finish = false
					double_points_icon_animation.play("default")
				
			"DoublePoints":
				texture = load("res://assets/IMG_1663.PNG")
				if Global.mecha_flight_player == 2:
					if area.player_number == 1:
						player1_double_point_icon_area.visible = true
						player1_double_point_icon_sprite.texture = texture
						Global.double_point_player1 = true
						Global.powerup_player1 = "DoublePoint"
						player1_double_point_icon.play("default")
						player1_double_point_icon.seek(0, true)
					else:
						player1_double_point_icon_area.visible = true
						player2_double_point_icon_sprite.texture = texture
						Global.double_point_player2 = true
						Global.powerup_player2 = "DoublePoint"
						player2_double_point_icon.play("default")
						player2_double_point_icon.seek(0, true)
				else:
					powerup_sprite.texture = texture
					Global.double_points = true
					Global.powerup = "DoublePoints"
					powerup_name.text = "2x POINTS"
					slow_down()
					powerup_animation.play("default")
					Global.powerup_animation_finish = false
					double_points_icon.play("default")
					double_points_icon.seek(0, true)
				
			"Magnet":
				texture = load("res://assets/IMG_1676.PNG")
				if Global.mecha_flight_player == 2:
					if area.player_number == 1:
						player1_magnet_icon_area.visible = true
						player1_magnet_icon_sprite.texture = texture
						Global.magnet_player1 = true
						Global.powerup_player1 = "Magnet"
						player1_magnet_icon.play("default")
						player1_magnet_icon.seek(0, true)
					else:
						player1_magnet_icon_area.visible = true
						player2_magnet_icon_sprite.texture = texture
						Global.magnet_player2 = true
						Global.powerup_player2 = "Magnet"
						player2_magnet_icon.play("default")
						player2_magnet_icon.seek(0, true)
				else:
					powerup_sprite.texture = texture
					Global.magnet = true
					Global.powerup = "Magnet"
					powerup_name.text = "Magnet"
					slow_down()
					powerup_animation.play("default")
					Global.powerup_animation_finish = false
					magnet_icon.play("default")
					magnet_icon.seek(0, true)
				
				
			"UnliBullet":
				texture = load("res://assets/IMG_1677.PNG")
				if Global.mecha_flight_player == 2:
					if area.player_number == 1:
						player1_unli_bullet_icon_area.visible = true
						player1_unli_bullet_icon_sprite.texture = texture
						Global.unli_bullet_player1 = true
						Global.powerup_player1 = "UnliBullet"
						player1_unli_bullet_icon.play("default")
						player1_unli_bullet_icon.seek(0, true)
						Global.mecha_flight_player1_bullets = 100
					else:
						player1_unli_bullet_icon_area.visible = true
						player2_unli_bullet_icon_sprite.texture = texture
						Global.unli_bullet_player2 = true
						Global.powerup_player2 = "UnliBullet"
						player2_unli_bullet_icon.play("default")
						player2_unli_bullet_icon.seek(0, true)
						Global.mecha_flight_player2_bullets = 100
				else:
					powerup_sprite.texture = texture
					Global.unli_bullet = true
					Global.powerup = "UnliBullet"
					powerup_name.text = "Unlimited Bullets"
					slow_down()
					powerup_animation.play("default")
					Global.powerup_animation_finish = false
					unli_bullet_icon.play("default")
					unli_bullet_icon.seek(0, true)
					Global.shoot_left = 100
				
				
func slow_down():
	Global.prev_meteor_speed = Global.meteor_speed
	Global.prev_speed = Global.speed
	Global.prev_object_speed = Global.object_speed
	
	Global.meteor_speed = 0
	Global.speed = 0
	Global.object_speed = Global.object_speed / 10.0
	
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
