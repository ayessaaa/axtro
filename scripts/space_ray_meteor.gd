extends Area2D

@export var type = "enemy_meteor"

@onready var character_animation = get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var space_ray_animation = get_parent().get_parent().get_node("AnimationPlayer")

@onready var corner_laser = get_parent().get_parent().get_node("Powerup/CornerLaser")
@onready var corner_laser_2 = get_parent().get_parent().get_node("Powerup/CornerLaser2")

@onready var hurt_sound = get_parent().get_parent().get_node("SpaceRayCharacter/HurtSound")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var x_speed 
var y_speed

func _ready() -> void:
	x_speed = randf_range(2.5, 5)
	y_speed = randf_range(0.5, 1.5)

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	position.y += y_speed
	position.x -= x_speed
	


func _on_area_entered(area: Area2D) -> void:
	if area.type == "player":
		if Global.space_ray_powerup == "invisible":
			return
		if Global.space_ray_hearts > 0:
			Global.space_ray_hearts -= 1
			corner_laser.play("red")
			corner_laser_2.play("red")
			space_ray_animation.play("player_hurt")
			character_animation.play("hurt")
			hurt_sound.play()
			queue_free()
	if area.type == "bullet" or  area.type == "red_bullet" or area.type == "bomb" or area.type == "snowball":
		Global.space_ray_score += 1 * Global.space_ray_multiplier
		Global.space_ray_weapon_score += 1 * Global.space_ray_multiplier
		animation_player.play("hurt")
	
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
