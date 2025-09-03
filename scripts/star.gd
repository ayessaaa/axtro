extends Area2D


@onready var score: Label = get_node("/root/Game/ScoreNode/Score")
@export var type = "star"
@onready var coin_sound = get_parent().get_node("CoinSound")
@onready var character = get_parent().get_parent().get_parent().get_node("Character")
@onready var progress_animation = get_parent().get_parent().get_parent().get_node("ProgressArea/AnimationPlayer")
@onready var angle_dash = get_parent().get_parent().get_parent().get_node("AngleDash/AnimationPlayer")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		coin_sound.play()
		animation_player.play("pick_up")
		
		if Global.double_points:
			Global.score += 2
			Global.next_mode_score += 2
			Global.meteor_speed += .5
		else:
			Global.score += 1
			Global.next_mode_score += 1
			Global.meteor_speed += .25
		score.text = "SCORE: "+ str(Global.score)
		score.show()
		
		if Global.spawn_interval > 0.5:
			Global.spawn_interval -= .1

		if Global.score >= 10:
			progress_animation.play("next_mode")
			Global.is_angle_dash = true
			angle_dash.play("fade_in")
		else:
			progress_animation.play("add_score")
			
func _process(delta: float) -> void:
	if Global.free_regular_mode_objects:
		self.queue_free()
		return
	if Global.magnet:
		position = position.move_toward(character.position, Global.speed * delta)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
