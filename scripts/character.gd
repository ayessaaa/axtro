extends Area2D

@export var speed = 400
@export var player: bool
var screen_size

@onready var sprite_2d: Sprite2D = $Sprite2D

const BULLET = preload("res://scenes/bullet.tscn")
@onready var bullets_container = get_parent().get_node("Bullets")

func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
		
	if Input.is_action_pressed("move_right") and position.x <= 1050:
		velocity.x += 1
	if Input.is_action_pressed("move_left") and position.x >= 100:
		velocity.x -= 1
	if Input.is_action_pressed("move_down") and position.y <= 520:
		velocity.y += 1
	if Input.is_action_pressed("move_up") and position.y >= 70:
		velocity.y -= 1
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
		
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized()
		position += velocity * speed * delta
		
func shoot():
	var bullet = BULLET.instantiate()
	bullet.position = position
	bullets_container.add_child(bullet)
	
