extends Area2D

@export var type = "enemy"
@onready var enemy: AnimatedSprite2D = $Enemy
@onready var laser_beam: AudioStreamPlayer2D = $LaserBeam
@onready var gun: Area2D = $Gun
@onready var health_area: Area2D = $Health
@onready var health_color_rect: ColorRect = $Health/ColorRect

const FIREBALL = preload("res://scenes/space_ray_fireball.tscn")
@onready var fireballs: Node = $Fireballs
@onready var fireball_sound: AudioStreamPlayer2D = $FireballSound

@onready var character = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SpaceRayCharacter")

var health = 100
var timer = 0.0

var health_rect_width

func _ready() -> void:
	health_rect_width = health_color_rect.size.x

func _on_area_entered(area: Area2D) -> void:
	print(area.type)
	if area.type == "laser":
		laser_beam.play()

func _on_area_exited(area: Area2D) -> void:
	if area.type == "laser":
		laser_beam.stop()
		

func _process(delta: float) -> void:
	if Global.start_screen or Global.is_angle_dash or Global.is_mecha_flight or Global.marathon:
		return
		
	for area in get_overlapping_areas():
		if area.type == "laser":
			health -= 10 *delta
			enemy.play("hurt")
		else:
			enemy.play("default")
			
	if len(get_overlapping_areas()) <= 0:
		enemy.play("default")
			#print(health)
	if health < 0:
		queue_free()
		
	timer += delta
	if timer >= Global.spawn_interval and Global.meteor_speed != 0:
		print("spawn")
		timer = 0
		spawn_fireball(gun.global_position)
		fireball_sound.play()
		
	health_color_rect.size.x = health_rect_width * (health/100)
		

func spawn_fireball(pos):
	var fireball = FIREBALL.instantiate()
	fireball.position = pos
	fireballs.add_child(fireball)
