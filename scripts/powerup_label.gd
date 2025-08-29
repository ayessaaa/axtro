extends Node


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.meteor_speed = 2.0
	Global.speed = Global.speed * 10.0
	Global.object_speed = Global.object_speed * 10.0
	
	match Global.powerup:
		"Shield":
			Global.shield = true
			Global.shield_animation = true
