extends CharacterBody2D

@export var type = "player"

@export var thrust_accel: float = 400.0
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
@onready var shooters: Node = $Shooters

@onready var sprite = get_node("SpaceRayCharacterArea/Sprite2D")
@onready var animation = get_node("SpaceRayCharacterArea/AnimationPlayer")

func _physics_process(delta: float) -> void:
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
		#Global.space_ray_weapon = "bomb"
		Global.space_ray_weapon = "bullet"
		
	if Input.is_action_just_pressed("e") and Global.space_ray_weapon == "bomb":
		spawn_shoot(position, BOMB)
	
	if Input.is_action_just_pressed("shoot") and Global.space_ray_weapon == "bullet":
		if rotation < 0:
			spawn_shoot(Vector2(position.x, position.y+10*rotation), BULLET)
		else:
			spawn_shoot(Vector2(position.x, position.y+10*rotation), BULLET)
			
		
	# rotate
	if Input.is_action_pressed("move_left") and rotation > -.1:
		rotation_velocity -= rotation_accel * delta
	elif Input.is_action_pressed("move_right") and rotation < .1:
		rotation_velocity += rotation_accel * delta
	else:
		rotation_velocity = move_toward(rotation_velocity, 0.0, rotation_decel * delta)

	if Input.is_action_pressed("move_right"):
		velocity += Vector2.RIGHT * thrust_accel * delta
		
	if Input.is_action_pressed("move_left"):
		velocity += Vector2.LEFT * thrust_accel * delta
	if Input.is_action_pressed("move_down"):
		velocity += Vector2.DOWN * thrust_accel * delta
	if Input.is_action_pressed("move_up"):
		velocity += Vector2.UP * thrust_accel * delta
		
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
		
func spawn_shoot(pos, shooter_scene):
	var shooter = shooter_scene.instantiate()
	shooter.position = pos
	shooters.add_child(shooter)
