extends CharacterBody2D

@export var thrust_accel: float = 400.0
@export var rotation_speed: float = 3.0
@export var max_speed: float = 600.0
@export var damping: float = 0.0 
@export var friction_factor: float = 0.98 

@export var rotation_accel: float = 4.0   # how fast angular velocity ramps up
@export var rotation_decel: float = 3.0   # how fast it slows when you let go
@export var max_rotation_speed: float = 2.0 # max radians per second

var rotation_velocity: float = 0.0

func _physics_process(delta: float) -> void:
	if Global.start_screen:
		return
	velocity *= friction_factor
	# rotate
	print(rotation)
	if Input.is_action_pressed("move_left") and rotation > -.1:
		print("left")
		rotation_velocity -= rotation_accel * delta
	elif Input.is_action_pressed("move_right") and rotation < .1:
		print("right")
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

	if damping > 0.0:
		velocity = velocity.move_toward(Vector2.ZERO, damping * delta)
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
		
	rotation_velocity = clamp(rotation_velocity, -max_rotation_speed, max_rotation_speed)
	rotation += rotation_velocity * delta
		
	print(velocity)

	move_and_slide()
