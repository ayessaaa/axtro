extends CharacterBody2D

const ACCEL = 800.0
const FRICTION = 200.0
const MAX_SPEED = 300.0
const GRAVITY = 200.0
const MAX_UP_SPEED = -200.0
const MAX_DOWN_SPEED = 400.0
const SMOOTHNESS = 5.0  

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_right: CollisionPolygon2D = $CollisionRight
@onready var collision_left: CollisionPolygon2D = $CollisionLeft

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta

	if Input.is_action_pressed("move_up"):
		velocity.y = lerp(velocity.y, MAX_UP_SPEED, delta * SMOOTHNESS)
	else:
		velocity.y = lerp(velocity.y, MAX_DOWN_SPEED, delta * (SMOOTHNESS / 2))

	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCEL * delta)
	else:
		if abs(velocity.x) > 1:
			var friction_dir = sign(velocity.x)
			velocity.x -= friction_dir * FRICTION * delta
		else:
			velocity.x = 0
			
	if Input.is_action_just_pressed("move_right"):
		sprite_2d.flip_h = false
		collision_right.disabled = false
		collision_left.disabled = true
	if Input.is_action_just_pressed("move_left"):
		sprite_2d.flip_h = true
		collision_right.disabled = true
		collision_left.disabled = false

	move_and_slide()
