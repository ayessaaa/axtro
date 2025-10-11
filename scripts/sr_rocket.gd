extends Area2D

@export var type = "enemy_rocket"

@onready var character_animation = get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var space_ray_animation = get_parent().get_parent().get_node("AnimationPlayer")
@onready var hurt_sound = get_parent().get_parent().get_node("SpaceRayCharacter/HurtSound")

@onready var corner_laser = get_parent().get_parent().get_node("Powerup/CornerLaser")
@onready var corner_laser_2 = get_parent().get_parent().get_node("Powerup/CornerLaser2")

@onready var progress_bar: ProgressBar = $Sprite2D/ProgressBar
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_animation: AnimationPlayer = $AnimationPlayer

var speed = 0
var health = 25
var freeze = false

func _ready() -> void:
	speed = randf_range(4, 7)

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	if health < 0:
		queue_free()
	if health < 25:
		progress_bar.value = health
		progress_bar.visible = true
	else:
		progress_bar.visible = false
		
	if Global.laser_enter:
		Global.rocket_position_laser = position
		#print("schanging stuffs")
	
	if freeze:
		health -= 0.05
	
	position.x -= speed


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
			sprite_animation.play("hurt")
	if area.type == "bullet" or area.type == "red_bullet" or area.type == "bomb":
		sprite_animation.play("hurt")
		Global.space_ray_score += 2 * Global.space_ray_multiplier
		Global.space_ray_weapon_score += 2 * Global.space_ray_multiplier
	if area.type == "snowball":
		sprite_animation.play("freeze")
		if !freeze:
			speed /= 2
		health -= 5
		freeze = true
		
		
	#if area.type == "laser" and Global.space_ray_weapon == "laser":
		##Global.laser_enter = true
		##Global.rocket_position_laser = position
		#health -= 10
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if freeze:
		freeze = false
		speed *= 2
	else:
		queue_free()
