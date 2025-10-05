extends Area2D

@export var type = "sr_star"

@onready var powerup_sound: AudioStreamPlayer2D = $PowerupSound

#var powerups = ["shrink", "triple", "invisible", "speed", "double"]
var powerups = ["double"]

func _process(delta: float) -> void:
	#position.x -= 2
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	if Global.space_ray_powerup != "":
		queue_free()
	position.y += 1.5


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		Global.space_ray_powerup = powerups[randi_range(0, len(powerups)-1)]
		queue_free()
