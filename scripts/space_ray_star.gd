extends Area2D

@export var type = "sr_star"

@onready var powerup_sound: AudioStreamPlayer2D = $PowerupSound
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

#var powerups = ["shrink", "triple", "invisible", "speed", "double", "machine_gun", "big_bomb"]
#var Global.space_ray_powerups = [ "machine_gun", "big_bomb"]

var pickup = false

func _process(delta: float) -> void:
	#position.x -= 2
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	if Global.space_ray_powerup != "":
		sprite_2d.play("pickup")
	if pickup:
		return
	position.y += 1.5


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		Global.space_ray_powerup = Global.space_ray_powerups[randi_range(0, len(Global.space_ray_powerups)-1)]
		sprite_2d.play("pickup")
		pickup = true


func _on_sprite_2d_animation_finished() -> void:
	queue_free()
