extends CharacterBody2D

@export var type = "player"

#@export var thrust_accel: float = 400.0
@export var rotation_speed: float = 3.0
@export var max_speed: float = 600.0
@export var damping: float = 0.0 
@export var friction_factor: float = 0.98 

@export var rotation_accel: float = 1.5   # how fast angular velocity ramps up
@export var rotation_decel: float = 3.0   # how fast it slows when you let go
@export var max_rotation_speed: float = 2.0 # max radians per second

var rotation_velocity: float = 0.0

const BOMB = preload("res://scenes/space_ray_bomb.tscn")
const BULLET = preload("res://scenes/space_ray_bullet.tscn")
const RAY = preload("res://scenes/space_ray_ray.tscn")
const SNOWBALL = preload("res://scenes/space_ray_snowball.tscn")
@onready var shooters: Node = $Shooters

@onready var sprite = get_node("SpaceRayCharacterArea/Sprite2D")
@onready var animation = get_node("SpaceRayCharacterArea/AnimationPlayer")

@onready var laser_sound = get_parent().get_node("SoundEffects/Laser")
@onready var bullet_sound = get_parent().get_node("SoundEffects/BulletSound")
@onready var snowball_sound = get_parent().get_node("SoundEffects/SnowballSound")

@onready var weapon_text_animation = get_parent().get_node("CurrentWeapon/AnimationPlayer")
@onready var damage_label: Label = $"../CurrentWeapon/DamageLabel"
@onready var cooldown_label: Label = $"../CurrentWeapon/CooldownLabel"

var weapons_stats = {"bullet": {"dmg": "25", "cooldown" : "0.5 s"},
					"ray": {"dmg": "15", "cooldown" : "0.3 s"},
					"snowball": {"dmg": "5", "cooldown" : "0.4 s"},
					"bomb": {"dmg": "40", "cooldown" : "one bomb at a time"}, }
var weapon_index = 0
var bullet_cooldown = 0.0
var snowball_cooldown = 0.0
var ray_cooldown = 0.0

func _physics_process(delta: float) -> void:
	if Global.space_ray_stop:
		return
	visible = Global.is_space_ray
	if Global.dead:
		sprite.pause()
		animation.stop()
		return
	if !Global.is_space_ray:
		return
	if Global.start_screen or Global.is_angle_dash or Global.is_mecha_flight or Global.marathon:
		return
	velocity *= friction_factor
	
	
	if Input.is_action_just_pressed("q"):
		weapon_text_animation.play("new_weapon")
		if weapon_index < len(Global.space_ray_weapons)-1:
			weapon_index += 1
		else:
			weapon_index = 0
			
		damage_label.text = "dmg: "+weapons_stats[Global.space_ray_weapons[weapon_index]]["dmg"]
		cooldown_label.text = "cooldown: "+weapons_stats[Global.space_ray_weapons[weapon_index]]["cooldown"]
		Global.space_ray_weapon = Global.space_ray_weapons[weapon_index]
		if Global.space_ray_weapon == "laser":
			laser_sound.play()
		
	if Input.is_action_just_pressed("shoot") and Global.space_ray_weapon == "bomb" and !Global.theres_bomb:
		#if Global.space_ray_powerup == "triple":
		spawn_shoot(position, BOMB, "bomb")
		
		
	
	bullet_cooldown = shoot_weapon(bullet_cooldown, delta, "bullet", BULLET, 0.5, bullet_sound)
	ray_cooldown = shoot_weapon(ray_cooldown, delta, "ray", RAY, 0.3, bullet_sound)
	snowball_cooldown = shoot_weapon(snowball_cooldown, delta, "snowball", SNOWBALL, 0.4, snowball_sound)
			
	if Global.space_ray_powerup == "invisible":
		type = "invisible"
	else:
		type = "player"
		
			
		
	# rotate
	if Input.is_action_pressed("move_left") and rotation > -.1:
		rotation_velocity -= rotation_accel * delta
	elif Input.is_action_pressed("move_right") and rotation < .1:
		rotation_velocity += rotation_accel * delta
	else:
		rotation_velocity = move_toward(rotation_velocity, 0.0, rotation_decel * delta)

	if Input.is_action_pressed("move_right"):
		velocity += Vector2.RIGHT * Global.space_ray_thrust_accel * delta
		
	if Input.is_action_pressed("move_left"):
		velocity += Vector2.LEFT * Global.space_ray_thrust_accel * delta
	if Input.is_action_pressed("move_down"):
		velocity += Vector2.DOWN * Global.space_ray_thrust_accel * delta
	if Input.is_action_pressed("move_up"):
		velocity += Vector2.UP * Global.space_ray_thrust_accel * delta
		
	if position.x > 1075:
		position.x = 1075
	if position.x < 70:
		position.x = 70
	if position.y > 600:
		position.y = 600
	if position.y < 55:
		position.y = 55
		
	if damping > 0.0:
		velocity = velocity.move_toward(Vector2.ZERO, damping * delta)
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
		
	rotation_velocity = clamp(rotation_velocity, -max_rotation_speed, max_rotation_speed)
	rotation += rotation_velocity * delta
		
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		print("Collision point: ", collision.get_position())


func _on_space_ray_character_area_area_entered(area: Area2D) -> void:
	if !Global.is_space_ray:
		return
	if area.type == "enemy":
		print("dead")
		
func spawn_shoot(pos, shooter_scene, type, direct=Vector2.RIGHT.rotated(rotation), rotate=rotation):
	var shooter = shooter_scene.instantiate()
	shooter.position = pos
	if type == "bullet" or type == "snowball" or type == "ray":
		shooter.direction = direct
		shooter.rotation = rotate
	shooters.add_child(shooter)
	
func shoot_weapon(cooldown, delta, weapon, weapon_scene, cooldown_time, sound):
	if Global.space_ray_powerup == "machine_gun" and Global.space_ray_weapon == weapon:
		if cooldown <= 0:
			cooldown = cooldown_time/2
			sound.play()
			spawn_shoot(Vector2(position.x, position.y+10*rotation), weapon_scene, weapon, Vector2.RIGHT.rotated(rotation), rotation)
	else:
		if Input.is_action_just_pressed("shoot") and Global.space_ray_weapon == weapon:
			if cooldown <= 0:
				cooldown = cooldown_time
				if Global.space_ray_powerup == "triple":
					sound.play()
					spawn_shoot(Vector2(position.x, position.y+10*rotation), weapon_scene, weapon, Vector2.RIGHT.rotated(rotation+.5), rotation+.5)
					spawn_shoot(Vector2(position.x, position.y+10*rotation), weapon_scene, weapon, Vector2.RIGHT.rotated(rotation), rotation)
					spawn_shoot(Vector2(position.x, position.y+10*rotation), weapon_scene, weapon, Vector2.RIGHT.rotated(rotation-.5), rotation-.5)
				else:
					sound.play()
					spawn_shoot(Vector2(position.x, position.y+10*rotation), weapon_scene, weapon, Vector2.RIGHT.rotated(rotation), rotation)
	return cooldown - delta
	
