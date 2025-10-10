extends Area2D

@export var type = "enemy"
@onready var enemy: AnimatedSprite2D = $Enemy
@onready var laser_beam: AudioStreamPlayer2D = $LaserBeam
@onready var gun: Area2D = $Gun
@onready var health_area: Area2D = $Health
#@onready var health_color_rect: ColorRect = $Health/ColorRect
@onready var progress_bar: ProgressBar = $Health/ProgressBar

const FIREBALL = preload("res://scenes/space_ray_fireball.tscn")
@onready var fireballs: Node = $Fireballs
@onready var fireball_sound: AudioStreamPlayer2D = $FireballSound

@onready var character = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter")
@onready var character_animation = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter/SpaceRayCharacterArea/AnimationPlayer")
@onready var hurt_sound = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter/HurtSound")
@onready var space_ray_animation = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("AnimationPlayer")
@onready var bg_music = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayMusic")
@onready var enemy_loop_sound = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SoundEffects/EnemyLoopSound")
@onready var enemy_dead_sound = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SoundEffects/EnemyDead")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

@onready var corner_laser = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Powerup/CornerLaser")
@onready var corner_laser_2 = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Powerup/CornerLaser2")


var health = 100
var timer = 0.0

var health_rect_width

func _ready() -> void:
	progress_bar.value = health

func _on_area_entered(area: Area2D) -> void:
	if area.type == "bullet":
		health -= 10
		animation_player.play("hurt")
	elif  area.type == "red_bullet":
		health -= 20
		animation_player.play("hurt")
	if area.type == "bomb":
		health -= 20
		animation_player.play("hurt")
	if health <= 0:
		animation_player.play("dead")
		enemy_dead_sound.play()
		enemy_loop_sound.stop()
		Global.space_ray_score += 10 * Global.space_ray_multiplier
		Global.space_ray_weapon_score += 10 * Global.space_ray_multiplier
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

	#if area.type == "laser":
		#laser_beam.play()

func _process(delta: float) -> void:
	if !Global.is_space_ray or Global.dead:
		return
	if Global.space_ray_stop:
		return
	
	position = Vector2(500, 500)
		
			
	if len(get_overlapping_areas()) <= 0:
		enemy.play("default")
			#print(health)
	if health <= 0:
		bg_music.volume_db = 0
		
		collision_polygon_2d.disabled = true
		
		if fireballs.get_child_count() == 0:
			queue_free()
		#queue_free()
		
	timer += delta
	if timer >= Global.space_ray_spawn_interval and health > 0:
		timer = 0
		spawn_fireball(gun.global_position)
		fireball_sound.play()
		
	progress_bar.value = health
		

func spawn_fireball(pos):
	var fireball = FIREBALL.instantiate()
	fireball.position = pos
	fireballs.add_child(fireball)
