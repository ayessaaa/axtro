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

@onready var selected_sound = get_parent().get_node("SelectedSound")

var shoot_cooldown_time = 0

var timer = 0.0

@onready var shield_bubble: Node = $ShieldBubble
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	screen_size = get_viewport_rect().size
	Global.screen_size = get_viewport_rect().size
	
var down_sub_counter = 0
var down_sub_counter2 = 0

var up_sub_counter = 0
var up_sub_counter2 = 0

func _process(delta: float) -> void:
	visible = Global.mecha_flight_player == 2
	if Global.mecha_flight_player < 2 or !Global.is_mecha_flight:
		return
		
	if Global.dead or Global.start_screen:
		return
	if Global.is_angle_dash or Global.is_space_ray:
		return
	if !Global.marathon and !Global.is_mecha_flight:
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	
	#shield_bubble.visible = Global.shield
	
	if Global.shield_animation:
		animation_player.play("shield_fade_in")
		animation_player.queue("default")
		Global.shield_animation = false
		
		
	if Input.is_action_pressed("arrow_right") and position.x <= 1050:
		velocity.x += 1
	if Input.is_action_pressed("arrow_left") and position.x >= 100:
		velocity.x -= 1
	if Input.is_action_pressed("arrow_down") and position.y <= 520:
		velocity.y += 1
		if Input.is_action_just_pressed("arrow_down"):
			animated_sprite_2d.play("down_sub")
		else:
			if down_sub_counter >= 1:
				animated_sprite_2d.play("down")
			else:
				down_sub_counter += delta * 10

	if Input.is_action_pressed("arrow_up") and position.y >= 70:
		velocity.y -= 1
		if Input.is_action_just_pressed("arrow_up"):
			animated_sprite_2d.play("up_sub")
		else:
			if up_sub_counter >= 1:
				animated_sprite_2d.play("up")
			else:
				up_sub_counter += delta * 10
		
	if Input.is_action_pressed("arrow_down") or Input.is_action_pressed("arrow_up"):
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
		
func shoot():
	if Global.shoot_left <= 0:
		return
	var bullet = BULLET.instantiate()
	bullet.position = Vector2(position.x+100, position.y)
	bullets_container.add_child(bullet)
	Global.shoot_left -= 1
