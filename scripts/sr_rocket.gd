extends Area2D

@export var type = "enemy_rocket"

var speed = 0

func _ready() -> void:
	speed = randf_range(4, 7)

func _process(delta: float) -> void:
	visible = Global.is_space_ray
	if !Global.is_space_ray:
		return
		
	position.x -= speed
