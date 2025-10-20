extends CharacterBody2D

const ACCEL = 800.0
const FRICTION = 200.0
const MAX_SPEED = 300.0
const GRAVITY = 200.0
const MAX_UP_SPEED = -200.0
const MAX_DOWN_SPEED = 400.0
const SMOOTHNESS = 5.0  

@onready var collision_right: CollisionPolygon2D = $CollisionRight
@onready var collision_left: CollisionPolygon2D = $CollisionLeft
@onready var red_sprite: AnimatedSprite2D = $RedSprite
@onready var green_sprite: AnimatedSprite2D = $GreenSprite

#func _ready() -> void:
	#sprite_2d.texture = load("res://images/new_texture.png")

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	red_sprite.visible = false
	
	if Input.is_action_pressed("arrow_up"):
		velocity.y = lerp(velocity.y, MAX_UP_SPEED, delta * SMOOTHNESS)
	else:
		velocity.y = lerp(velocity.y, MAX_DOWN_SPEED, delta * (SMOOTHNESS / 2))

	var direction := Input.get_axis("arrow_left", "arrow_right")

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCEL * delta)
	else:
		if abs(velocity.x) > 1:
			var friction_dir = sign(velocity.x)
			velocity.x -= friction_dir * FRICTION * delta
		else:
			velocity.x = 0
			
	if Input.is_action_just_pressed("arrow_right"):
		green_sprite.flip_h = false
		collision_right.disabled = false
		collision_left.disabled = true
	if Input.is_action_just_pressed("arrow_left"):
		green_sprite.flip_h = true
		collision_right.disabled = true
		collision_left.disabled = false

	move_and_slide()
