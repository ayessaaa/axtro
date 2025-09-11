extends CharacterBody2D

@export var type = "player"

@export var thrust_accel: float = 450.0
@export var rotation_speed: float = 3.0
@export var max_speed: float = 600.0
@export var damping: float = 0.0 
@export var friction_factor: float = 0.96

@export var rotation_accel: float = 1.5   # how fast angular velocity ramps up
@export var rotation_decel: float = 3.0   # how fast it slows when you let go
@export var max_rotation_speed: float = 2.0 # max radians per second

var rotation_velocity: float = 0.0


func _physics_process(delta: float) -> void:
	if Global.start_screen or !Global.is_ocean_rhythm:
		return
	velocity *= friction_factor
	
		
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
