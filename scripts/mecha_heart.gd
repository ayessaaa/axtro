extends Area2D
@export var type = "heart"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var heart_collected_sound: AudioStreamPlayer2D = $HeartCollectedSound
#func _process(delta: float) -> void:
	#

func _on_area_entered(area: Area2D) -> void:
	if area.player:
		Global.hearts += 1
		animation_player.play("collected")
		heart_collected_sound.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
