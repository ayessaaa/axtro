extends Area2D

@export var speed = 400
var screen_size

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
		
	if Input.is_action_pressed("move_right") and position.x <= 850:
		velocity.x += 1
	if Input.is_action_pressed("move_left") and position.x >= -100:
		velocity.x -= 1
	if Input.is_action_pressed("move_down") and position.y <= 450:
		velocity.y += 1
	if Input.is_action_pressed("move_up") and position.y >= -20:
		velocity.y -= 1
		
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized()
		position += velocity * speed * delta
	
