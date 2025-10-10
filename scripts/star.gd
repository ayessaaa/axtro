extends Area2D


@onready var score: Label = get_node("/root/Game/ScoreNode/Score")
@onready var player1_score: Label = get_node("/root/Game/TwoPlayers/Player1/Score")
@onready var player2_score: Label = get_node("/root/Game/TwoPlayers/Player2/Score")
@export var type = "star"
@onready var coin_sound = get_parent().get_node("CoinSound")
@onready var character = get_parent().get_parent().get_parent().get_node("Character")
@onready var progress_animation = get_parent().get_parent().get_parent().get_node("ProgressArea/AnimationPlayer")
@onready var angle_dash = get_parent().get_parent().get_parent().get_node("AngleDash/AnimationPlayer")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func  _ready() -> void:
	animation_player.play("disappearing")

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		coin_sound.play()
		animation_player.play("pick_up")
		
		if Global.double_points:
			if Global.is_mecha_flight:
				if Global.mecha_flight_player == 1:
#					singleplayer
					Global.score += 2
				else:
#					multiplayer
					if area.player_number == 1:
						Global.mecha_flight_player1_score += 2
					else:
						Global.mecha_flight_player2_score += 2
			else:
				Global.score += 2
				Global.next_mode_score += 2
			Global.meteor_speed += .5
		else:
			if Global.is_mecha_flight:
				if Global.mecha_flight_player == 1:
#					singleplayer
					Global.score += 1
				else:
#					multiplayer
					if area.player_number == 1:
						Global.mecha_flight_player1_score += 1
					else:
						Global.mecha_flight_player2_score += 1
			else:
				Global.score += 1
				Global.next_mode_score += 1
			Global.meteor_speed += .25
			
		if Global.mecha_flight_player == 2:
			player1_score.text = "SCORE: "+str(Global.mecha_flight_player1_score)
			player2_score.text = "SCORE: "+str(Global.mecha_flight_player2_score)
			
		else:
			score.text = "SCORE: "+ str(Global.score)
			score.show()
		
		if Global.spawn_interval > 0.5:
			Global.spawn_interval -= .1
			
		if Global.marathon:

			if Global.score >= 10:
				progress_animation.play("next_mode")
				Global.is_angle_dash = true
				angle_dash.play("fade_in")
			else:
				progress_animation.play("add_score")
			
func _process(delta: float) -> void:
	if Global.start_screen or Global.is_space_ray:
		return
	#if Global.free_regular_mode_objects:
		#queue_free()
		#return
	if Global.magnet:
		position = position.move_toward(character.position, Global.speed * delta)
	if Global.meteor_speed == 0:
		animation_player.pause()
	else:
		animation_player.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
