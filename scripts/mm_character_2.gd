extends CharacterBody2D

const ACCEL = 800.0
const FRICTION = 200.0
const MAX_SPEED = 300.0
const GRAVITY = 200.0
const MAX_UP_SPEED = -200.0
const MAX_DOWN_SPEED = 400.0
const SMOOTHNESS = 5.0  
const SPEED = 200

@onready var blue_sprite: AnimatedSprite2D = $BlueSprite
@onready var green_sprite: AnimatedSprite2D = $GreenSprite
@onready var line: Sprite2D = $Line
@onready var area_collision_right: CollisionPolygon2D = $CharacterArea2/CollisionRight
@onready var area_collision_left: CollisionPolygon2D = $CharacterArea2/CollisionLeft

#func _ready() -> void:
	#sprite_2d.texture = load("res://images/new_texture.png")

func _physics_process(delta: float) -> void:
	if Global.mm_pause:
		velocity.x = 0
		return
	velocity.y += GRAVITY * delta
	blue_sprite.visible = false
	
	if Global.mm_player2_gravity:
		line.visible = false
		if Input.is_action_pressed("arrow_up"):
			green_sprite.play("up")
			velocity.y = lerp(velocity.y, MAX_UP_SPEED, delta * SMOOTHNESS)
		else:
			if is_on_floor():
				green_sprite.play("default")
			else:
				green_sprite.play("down")
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
	else:
		line.visible = true

		var direction := Input.get_axis("arrow_left", "arrow_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		var vertical := Input.get_axis("arrow_up", "arrow_down")
		if Input.is_action_pressed("arrow_up"):
			green_sprite.play("up")
		elif Input.is_action_pressed("arrow_down"):
			green_sprite.play("down")
		else:
			green_sprite.play("default")
		if vertical:
			velocity.y = vertical * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		
		
	if Input.is_action_just_pressed("arrow_right"):
		green_sprite.flip_h = false
	if Input.is_action_just_pressed("arrow_left"):
		green_sprite.flip_h = true
		

	move_and_slide()
