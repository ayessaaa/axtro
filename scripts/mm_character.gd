extends CharacterBody2D

@export var type = "player1"

const ACCEL = 800.0
const FRICTION = 200.0
const MAX_SPEED = 300.0
const GRAVITY = 200.0
const MAX_UP_SPEED = -200.0
const MAX_DOWN_SPEED = 400.0
const SMOOTHNESS = 5.0  
const SPEED = 200

@onready var collision_right: CollisionPolygon2D = $CollisionRight
@onready var collision_left: CollisionPolygon2D = $CollisionLeft
@onready var blue_sprite: AnimatedSprite2D = $BlueSprite
@onready var green_sprite: AnimatedSprite2D = $GreenSprite
@onready var line: Sprite2D = $Line
@onready var area_collision_right: CollisionPolygon2D = $CharacterArea1/CollisionRight
@onready var area_collision_left: CollisionPolygon2D = $CharacterArea1/CollisionLeft

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	green_sprite.visible = false
	
	if Global.mm_player1_gravity:
		line.visible = false
		
		if Input.is_action_pressed("move_up"):
			blue_sprite.play("up")
			velocity.y = lerp(velocity.y, MAX_UP_SPEED, delta * SMOOTHNESS)
		else:
			if is_on_floor():
				blue_sprite.play("default")
			else:
				blue_sprite.play("down")
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
	else:
		line.visible = true

		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		var vertical := Input.get_axis("move_up", "move_down")
		if vertical:
			velocity.y = vertical * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)

	
			
	if Input.is_action_just_pressed("move_right"):
		blue_sprite.flip_h = false
		collision_right.disabled = false
		area_collision_right.disabled = false
		collision_left.disabled = true
		area_collision_left.disabled = true
	if Input.is_action_just_pressed("move_left"):
		blue_sprite.flip_h = true
		collision_right.disabled = true
		area_collision_right.disabled = true
		collision_left.disabled = false
		collision_left.disabled = false
		
	

	move_and_slide()
