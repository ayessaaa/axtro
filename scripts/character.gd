extends Area2D

@export var speed = 400
@export var player = true
var screen_size

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const METEOR = preload("res://scenes/meteor.tscn")
@onready var meteors_container = get_parent().get_node("Meteors")

const BULLET = preload("res://scenes/bullet.tscn")
@onready var bullets_container = get_parent().get_node("Bullets")

var spawn_interval = 2.0
var timer = 0.0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	spawn_meteor(Vector2(1200, randf_range(50, screen_size[1]-100)))
	spawn_meteor(Vector2(1500, randf_range(50, screen_size[1]-100)))
	spawn_meteor(Vector2(1800, randf_range(50, screen_size[1]-100)))
	spawn_meteor(Vector2(2000, randf_range(50, screen_size[1]-100)))
	
var down_sub_counter = 0
var down_sub_counter2 = 0

var up_sub_counter = 0
var up_sub_counter2 = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.dead:
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	
		
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
		position += velocity * speed * delta
		
	timer += delta
	if timer >= spawn_interval:
		timer = 0
		spawn_meteor(Vector2(2000, randf_range(50, screen_size[1]-100)))
		
func shoot():
	var bullet = BULLET.instantiate()
	bullet.position = position
	bullets_container.add_child(bullet)
	
func spawn_meteor(pos):
	var meteor = METEOR.instantiate()
	meteor.position = pos
	meteors_container.add_child(meteor)
	
	
