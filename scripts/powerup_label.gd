extends Node


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.meteor_speed = Global.prev_meteor_speed
	Global.speed = Global.prev_speed
	Global.object_speed = Global.prev_object_speed
	
	match Global.powerup:
		"Shield":
			if Global.mecha_flight_player != 2:
				Global.shield = true
				Global.shield_animation = true
