extends Sprite2D

@export var speed = 400
@export var object: Node 
@export var character: bool 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.dead:
		return
	if object == null:
		return
		
	var velocity = Vector2.ZERO # The player's movement vector.
	if character:	
			
		if Input.is_action_pressed("move_right") and object.position.x <= 1050:
			velocity.x += 1
		if Input.is_action_pressed("move_left") and object.position.x >= 100:
			velocity.x -= 1
		if Input.is_action_pressed("move_down") and object.position.y <= 520:
			velocity.y += 1
		if Input.is_action_pressed("move_up") and object.position.y >= 70:
			velocity.y -= 1
			
		if velocity != Vector2.ZERO:
			velocity = velocity.normalized()
			position += velocity * speed * delta
	else:
		position.x = object.position.x
