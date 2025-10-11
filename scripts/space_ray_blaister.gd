extends Area2D

@export var type = "enemy_blaister"

@onready var character_animation = get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var space_ray_animation = get_parent().get_parent().get_node("AnimationPlayer")
@onready var hurt_sound = get_parent().get_parent().get_node("SpaceRayCharacter/HurtSound")

@onready var corner_laser = get_parent().get_parent().get_node("Powerup/CornerLaser")
@onready var corner_laser_2 = get_parent().get_parent().get_node("Powerup/CornerLaser2")

@onready var progress_bar: ProgressBar = $Sprite2D/ProgressBar
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite_animation: AnimationPlayer = $AnimationPlayer
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

var speed = 0
var health = 100
var freeze = false

func _ready() -> void:
	speed = randf_range(1, 2)

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	if health <= 0:
		sprite_animation.play("death")
		collision_polygon_2d.disabled = true
	if health < 100:
		progress_bar.value = health
		progress_bar.visible = true
	else:
		progress_bar.visible = false
		
	if Global.laser_enter:
		Global.rocket_position_laser = position
		#print("schanging stuffs")
		
	if freeze:
		health -= .1
	
		
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
	if area.type == "snowball":
		sprite_animation.play("freeze")
		if !freeze:
			speed /= 2
		health -= 5
		freeze = true
	
	elif Global.space_ray_weapon_dmg.keys().has(area.type):
		health -= Global.space_ray_weapon_dmg[area.type]
		if health > 0:
			sprite_animation.play("hurt")
		
	if health <= 0:
		sprite_animation.play("death")
		

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if freeze:
		freeze = false
	if health <= 0:
		Global.space_ray_score += 4 * Global.space_ray_multiplier
		Global.space_ray_weapon_score += 4 * Global.space_ray_multiplier
		queue_free()
	
	
