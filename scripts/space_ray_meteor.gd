extends Area2D

@export var type = "enemy_meteor"

var x_speed 
var y_speed

func _ready() -> void:
	x_speed = randf_range(2.5, 5)
	y_speed = randf_range(0.5, 1.5)

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray or Global.dead:
		return
	position.y += y_speed
	position.x -= x_speed
