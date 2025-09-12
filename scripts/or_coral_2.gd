extends Sprite2D

var speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = randf_range(80, 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.x < -500:
		queue_free()
	position.x -= speed * delta
