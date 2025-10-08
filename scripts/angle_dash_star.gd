extends Area2D

@export var type = "ad_star"

@onready var coin_sound = get_parent().get_node("CoinSound")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


#func _process(delta: float) -> void:
	#self.visible = Global.is_angle_dash
	#if Global.dead:
		#return
	#if Global.angle_dash_animation_finished:
		#position.x -= delta * Global.spike_speed
#
func _on_area_entered(area: Area2D) -> void:
	if area.player and self.visible:
		Global.angle_dash_score += 1
		Global.score += 1
		coin_sound.play()
		animation_player.play("pick_up")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
