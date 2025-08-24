extends Sprite2D

@export var speed = 400
@export var object_path: NodePath 
@export var character: bool 
@onready var object: Area2D = get_node(object_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if character:	
			
		if Input.is_action_pressed("move_right") and object.position.x <= 1050:
			velocity.x += 1
		if Input.is_action_pressed("move_left") and object.position.x >= 100:
			velocity.x -= 1
		if Input.is_action_pressed("move_down") and object.position.y <= 580:
			velocity.y += 1
		if Input.is_action_pressed("move_up") and object.position.y >= 70:
			velocity.y -= 1
			
		if velocity != Vector2.ZERO:
			velocity = velocity.normalized()
			position += velocity * speed * delta
	else:
		position.x = object.position.x
