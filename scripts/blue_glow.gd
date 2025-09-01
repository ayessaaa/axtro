extends Sprite2D

var start_pos: Vector2
var end_pos: Vector2
var direction: int

func start(pos: Vector2, dir: int) -> void:
	start_pos = pos
	end_pos = pos
	direction = dir
	rotation_degrees = 42 if dir > 0 else -44
	if dir < 0:
		texture = load("res://assets/IMG_1695.PNG")
		self.texture = texture
	scale.x = 0.1   # start tiny

func extend_to(new_end: Vector2, delta: float) -> void:
	# Move both start and end left
	start_pos.x -= Global.angle_dash_speed * delta
	end_pos = new_end
	end_pos.x -= Global.angle_dash_speed * delta

	# Middle point
	global_position = (start_pos + end_pos) / 2

	# Stretch
	var length = start_pos.distance_to(end_pos)
	scale.x = length / texture.get_size().x
	
func _process(delta: float) -> void:
	global_position.x -= Global.angle_dash_speed * delta
