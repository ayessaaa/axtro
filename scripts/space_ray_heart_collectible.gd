extends Area2D

@export var type = "sr_heart"

@onready var powerup_sound: AudioStreamPlayer2D = $PowerupSound
@onready var heart_collected_sound: AudioStreamPlayer2D = $HeartCollectedSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	#position.x -= 2
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	position.y += 1.5


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		Global.space_ray_hearts += 1
		heart_collected_sound.play()
		animation_player.play("collected")
		

func _on_heart_collected_sound_finished() -> void:
	queue_free()
