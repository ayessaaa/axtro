extends Area2D

@export var player = true
var screen_size

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_cooldown_area: Area2D = $"../BulletCooldown/BulletCooldownArea"
@onready var bullet_cooldown_area_2: Area2D = $"../BulletCooldown/BulletCooldownArea2"
@onready var bullet_cooldown_area_3: Area2D = $"../BulletCooldown/BulletCooldownArea3"

const METEOR = preload("res://scenes/meteor.tscn")
const SMALL_METEOR = preload("res://scenes/small_meteor.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")
@onready var meteors_container = get_parent().get_node("Meteors")

const BULLET = preload("res://scenes/bullet.tscn")
@onready var bullets_container = get_parent().get_node("Bullets")

var shoot_left = 3
var shoot_cooldown_time = 0

var timer = 0.0

@onready var shield_bubble: Node = $ShieldBubble
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	screen_size = get_viewport_rect().size
	spawn_asteroid(Vector2(1200, randf_range(50, screen_size[1]-100)))
	spawn_small_meteor(Vector2(1500, randf_range(50, screen_size[1]-100)))
	spawn_meteor(Vector2(1800, randf_range(50, screen_size[1]-100)))
	spawn_small_meteor(Vector2(2000, randf_range(50, screen_size[1]-100)))
	
var down_sub_counter = 0
var down_sub_counter2 = 0

var up_sub_counter = 0
var up_sub_counter2 = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.dead:
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	
	#shield_bubble.visible = Global.shield
	
	if Global.shield_animation:
		animation_player.play("shield_fade_in")
		animation_player.queue("default")
		Global.shield_animation = false
		
		
	if Input.is_action_pressed("move_right") and position.x <= 1050:
		velocity.x += 1
	if Input.is_action_pressed("move_left") and position.x >= 100:
		velocity.x -= 1
	if Input.is_action_pressed("move_down") and position.y <= 520:
		velocity.y += 1
		if Input.is_action_just_pressed("move_down"):
			animated_sprite_2d.play("down_sub")
		else:
			if down_sub_counter >= 1:
				animated_sprite_2d.play("down")
			else:
				down_sub_counter += delta * 10

	if Input.is_action_pressed("move_up") and position.y >= 70:
		velocity.y -= 1
		if Input.is_action_just_pressed("move_up"):
			animated_sprite_2d.play("up_sub")
		else:
			if up_sub_counter >= 1:
				animated_sprite_2d.play("up")
			else:
				up_sub_counter += delta * 10
		
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
		pass 
	else:
		
		if down_sub_counter > 0:
			animated_sprite_2d.play("down_sub")
			down_sub_counter2 += delta * 10
			if down_sub_counter2 >= 1:
				animated_sprite_2d.play("default")
				down_sub_counter = 0
				down_sub_counter2 = 0
		
		if up_sub_counter > 0:
			animated_sprite_2d.play("up_sub")
			up_sub_counter2 += delta * 10
			if up_sub_counter2 >= 1:
				animated_sprite_2d.play("default")
				up_sub_counter = 0
				up_sub_counter2 = 0
		
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized()
		position += velocity * Global.speed * delta
		
	timer += delta
	if timer >= Global.spawn_interval and Global.meteor_speed != 0:
		timer = 0
		if randi_range(0,20) < 1:
			spawn_asteroid(Vector2(2000, randf_range(50, screen_size[1]-100)))
		else:
			if randi_range(0,2) < 2:
				spawn_meteor(Vector2(2000, randf_range(50, screen_size[1]-100)))
			else:
				spawn_small_meteor(Vector2(2000, randf_range(50, screen_size[1]-100)))
			
	if shoot_left == 1:
		bullet_cooldown_area.available = true
		bullet_cooldown_area_2.available = false
		bullet_cooldown_area_3.available = false
	elif shoot_left == 2:
		bullet_cooldown_area.available = true
		bullet_cooldown_area_2.available = true
		bullet_cooldown_area_3.available = false
	elif shoot_left == 3:
		bullet_cooldown_area.available = true
		bullet_cooldown_area_2.available = true
		bullet_cooldown_area_3.available = true
	else:
		bullet_cooldown_area.available = false
		bullet_cooldown_area_2.available = false
		bullet_cooldown_area_3.available = false
		
	if shoot_left < 3:
		if shoot_cooldown_time > 2:
			shoot_left+=1
			shoot_cooldown_time = 0
		else:
			shoot_cooldown_time += delta
			
func shoot():
	if shoot_left <= 0:
		return
	var bullet = BULLET.instantiate()
	bullet.position = Vector2(position.x+100, position.y)
	bullets_container.add_child(bullet)
	shoot_left -= 1
	
func spawn_meteor(pos):
	var meteor = METEOR.instantiate()
	meteor.position = pos
	meteors_container.add_child(meteor)
	
func spawn_small_meteor(pos):
	var small_meteor = SMALL_METEOR.instantiate()
	small_meteor.position = pos
	meteors_container.add_child(small_meteor)
	
func spawn_asteroid(pos):
	var small_asteroid = ASTEROID.instantiate()
	small_asteroid.position = pos
	meteors_container.add_child(small_asteroid)
	
	
	
