extends Node

@onready var space_ray_heart_1: AnimatedSprite2D = $SpaceRayHeart1
@onready var space_ray_heart_2: AnimatedSprite2D = $SpaceRayHeart2
@onready var space_ray_heart_3: AnimatedSprite2D = $SpaceRayHeart3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	space_ray_heart_1.visible = Global.is_space_ray
	space_ray_heart_2.visible = Global.is_space_ray
	space_ray_heart_3.visible = Global.is_space_ray
	if !Global.is_space_ray:
		return
		
	match Global.space_ray_hearts:
		3:
			space_ray_heart_1.self_modulate.a = 1
			space_ray_heart_2.self_modulate.a = 1
			space_ray_heart_3.self_modulate.a = 1
		2:
			space_ray_heart_1.self_modulate.a = 1
			space_ray_heart_2.self_modulate.a = 1
			space_ray_heart_3.self_modulate.a = 0.2

		1:
			space_ray_heart_1.self_modulate.a = 1
			space_ray_heart_2.self_modulate.a = 0.2
			space_ray_heart_3.self_modulate.a = 0.2
		0:
			space_ray_heart_1.self_modulate.a = 0.2
			space_ray_heart_2.self_modulate.a = 0.2
			space_ray_heart_3.self_modulate.a = 0.2
