extends Area2D

@export var type = "ad_star"

@onready var stardust_sound = get_parent().get_node("StardustSound")
@onready var challenge_animation = get_parent().get_parent().get_parent().get_node("Challenges/AnimationPlayer")
@onready var challenge_title = get_parent().get_parent().get_parent().get_node("Challenges/Title")
@onready var challenge_description = get_parent().get_parent().get_parent().get_node("Challenges/Description")
@onready var challenge_progress = get_parent().get_parent().get_parent().get_node("Challenges/Progress")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var challenges = ["CLOSE CALL!"]


#func _process(delta: float) -> void:
	#self.visible = Global.is_angle_dash
	#if Global.dead:
		#return
	#if Global.angle_dash_animation_finished:
		#position.x -= delta * Global.spike_speed
#
func _on_area_entered(area: Area2D) -> void:
	if area.player and self.visible:
		Global.angle_dash_challenge = true
		Global.angle_dash_score += 1
		Global.score += 1
		stardust_sound.play()
		animation_player.play("pick_up")
		challenge_animation.play("fade_in")
		Global.angle_dash_challenge_name = challenges[randi_range(0, len(challenges))-1]
		challenge_title.text = Global.angle_dash_challenge_name
		challenge_description.text = Global.angle_dash_challenges[Global.angle_dash_challenge_name]["description"]
		challenge_progress.text = "0/"+str(Global.angle_dash_challenges[Global.angle_dash_challenge_name]["number"])


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
