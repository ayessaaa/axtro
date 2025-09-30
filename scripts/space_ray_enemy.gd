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
@onready var enemy_loop_sound = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SoundEffects/EnemyLoopSound")

var health = 100
var timer = 0.0

var health_rect_width

func _ready() -> void:
	progress_bar.value = health

func _on_area_entered(area: Area2D) -> void:
	if area.type == "bullet":
		health -= 10
		print(health)
	elif  area.type == "red_bullet":
		health -= 20
		print(health)
	if area.type == "bomb":
		health -= 20
		print("healthbomb")
	#if area.type == "laser":
		#laser_beam.play()

		

func _process(delta: float) -> void:
	if !Global.is_space_ray or Global.dead:
		return
	
	position = Vector2(500, 500)
		
			
	if len(get_overlapping_areas()) <= 0:
		enemy.play("default")
			#print(health)
	if health <= 0:
		enemy_loop_sound.stop()
		queue_free()
		
	timer += delta
	if timer >= Global.space_ray_spawn_interval:
		timer = 0
		spawn_fireball(gun.global_position)
		fireball_sound.play()
		
	progress_bar.value = health
		

func spawn_fireball(pos):
	var fireball = FIREBALL.instantiate()
	fireball.position = pos
	fireballs.add_child(fireball)
