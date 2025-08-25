extends Area2D

var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.dead:
		return
	if position.x <= -150:
		position.x = 1700
	else:
		position.x -= speed * delta * 60
