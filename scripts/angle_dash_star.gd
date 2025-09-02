extends Area2D

@onready var coin_sound = get_parent().get_node("CoinSound")


#func _process(delta: float) -> void:
	#self.visible = Global.is_angle_dash
	#if Global.dead:
		#return
	#if Global.angle_dash_animation_finished:
		#position.x -= delta * Global.spike_speed
#
func _on_area_entered(area: Area2D) -> void:
	if area.player:
		Global.score += 1
		print("lol "+str(Global.score))
		coin_sound.play()
		queue_free()
