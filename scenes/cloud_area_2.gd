extends Area2D

var speed = 2
var updown_cooldown = .05
var up_or_down = .10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updown_cooldown -= delta
	position.y += up_or_down
	rotation += up_or_down * .005
	if updown_cooldown <= .5:
		up_or_down *= -1
		updown_cooldown = 1
			
	if position.x <= -150:
		position.x = 1500
	else:
		position.x -= speed * delta * 50
		
